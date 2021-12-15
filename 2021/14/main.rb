# There are a couple examples in the comments in this file. These will use this simplified
# set of rules:
#
#   AA -> A
#   AB -> A
#   BA -> A
#   BB -> B
#

PART_1_STEPS = 10
PART_2_STEPS = 40
MAX_STEPS = [PART_1_STEPS, PART_2_STEPS].max

TEMPLATE = $<.gets.chomp

$<.gets  # eat up the empty line

RULES = $<.map.with_object({}) do |line, hash|
  parts = line.chomp.split(' -> ')
  hash[parts[0]] = parts[1]
end

# Look at the rules to see what characters we can expect
CHARS = RULES.values.uniq.sort

# While the CHARS array allows us to go from index to character, this map
# allows us to go from character to index within CHARS.
CHAR_INDEXES = CHARS.map.with_index.with_object({}) do |(char, index), hash|
  hash[char] = index
end

# Create every possible pair we'll expect to see in the template after any number
# of steps
PAIRS = CHARS.product(CHARS).map(&:join).sort

# Similar to CHAR_INDEXES, this map will allows us to go from pair to index within
# PAIRS.
PAIR_INDEXES = PAIRS.map.with_index.with_object({}) do |(pair, index), hash|
  hash[pair] = index
end

# Number of elements in the CHAR_COUNTS array that are tied to a single step
STEP_SIZE = CHARS.length ** 3

# Cache of counts of how often a character appears in a pair that has had the
# insertion rules applied a given number of steps. Caching this in a single
# array that is allocated up front will reduce the need to allocate bits of
# memory here and there, thus speeding things up.
#
# Example
# ───────
#
# Note: this uses the example rules in the top comment of this file.
#
# The first two steps of the cache array will look like the following. The `count`
# row at the bottom reflects the values in the array, the rows above that show how
# `step`, `pair` and `character` map to the index within the array.
#
#             ╓───────────────────────────────╥───────────────────────────────╥────
# step:       ║               0               ║               1               ║ ...
#             ╟───────┬───────┬───────┬───────╫───────┬───────┬───────┬───────╫────
# pair:       ║  AA   │  AB   │  BA   │  BB   ║  AA   │  AB   │  BA   │  BB   ║ ...
#             ╟───┬───┼───┬───┼───┬───┼───┬───╫───┬───┼───┬───┼───┬───┼───┬───╫────
# character:  ║ A │ B │ A │ B │ A │ B │ A │ B ║ A │ B │ A │ B │ A │ B │ A │ B ║ ...
#             ╠═══╪═══╪═══╪═══╪═══╪═══╪═══╪═══╬═══╪═══╪═══╪═══╪═══╪═══╪═══╪═══╬════
# count:      ║ 2 │ 0 │ 1 │ 1 │ 1 │ 1 │ 0 │ 2 ║ 3 │ 0 │ 2 │ 1 │ 2 │ 1 │ 0 │ 3 ║ ...
#             ╙───┴───┴───┴───┴───┴───┴───┴───╨───┴───┴───┴───┴───┴───┴───┴───╨────
#
CHAR_COUNTS = Array.new((MAX_STEPS + 1) * STEP_SIZE)

# Pointer used to walk through `CHAR_COUNTS` as we populate it
index = 0

# Populate step 0 in the cache. Character counts are simply based on the pair as no
# rules are applied.
PAIRS.each do |pair|
  CHARS.each.with_index do |char, char_index|
    CHAR_COUNTS[index + char_index] = if char == pair[0]
      pair[0] == pair[1] ? 2 : 1
    elsif char == pair[1]
      1
    else
      0
    end
  end
  index += CHARS.length
end

# Populate all steps from 1 up to the maximum number of steps. To calculate the counts at
# a given step and pair:
#
#   1. Apply the insertion rule for the pair (e.g. with `LR -> M` we have `LMR`)
#   2. Split the resulting string into a left pair and right pair (`LM` and `MR` from the
#      example above)
#   3. Sum the counts (per character) for the pairs at `step - 1`
#   4. Subtract 1 for the inserted character's count, since we counted that twice (once for
#      either pair)
#
# Example
# ───────
#
# Note: this uses the example rules in the top comment of this file.
#
# To determine the character counts for the pair `AB` at step 1, we follow the rules above
#
#   1. Applying the insertion rule to `AB` yields `AAB`
#   2. Splitting `AAB` into two pairs yields `AA` and `AB`
#   3. Character counts for step = 0 are
#      * `AA`: {"A": 2, "B": 0}
#      * `AB`: {"A": 1, "B": 1}
#      These sum up to {"A": 3, "B": 1}
#   4. Since the inserted `A` was counted in both `AA` and `AB`, subtract 1 from the `A`
#      count: {"A": 2, "B": 1}
#
(1..MAX_STEPS).each do |i|
  PAIRS.each do |pair|
    mid = RULES[pair]
    pair1 = pair[0] + mid
    pair2 = mid + pair[1]

    # If we subtract STEP_SIZE from our current index, we will get the index for the same
    # pair and character at the previous step. To move the pointer to the correct pair, we
    # can subtract the relative index of the pair index currently points to
    # (`PAIR_INDEXES[pair]`) and add the relative index of the other pair.
    look_back1 = - STEP_SIZE + (PAIR_INDEXES[pair1] - PAIR_INDEXES[pair]) * CHARS.length
    look_back2 = - STEP_SIZE + (PAIR_INDEXES[pair2] - PAIR_INDEXES[pair]) * CHARS.length

    CHARS.each do |char|
      # Add the charater counts for each pair, subtracting one if character was the one
      # we inserted based on the rules.
      CHAR_COUNTS[index] = CHAR_COUNTS[index + look_back1] +
        CHAR_COUNTS[index + look_back2] -
        (char == mid ? 1 : 0)
      index += 1
    end
  end
end

# Return the difference between the count of the most common and least common charaters
# in the string that results by applying the insertion rules on the template for the
# given number of steps.
def score(template, steps)
  # Zero out an array of counts for each possible character
  counts = [0] * CHARS.size

  # In a process similar to how we precompute the values in `CHAR_COUNTS` for steps 1
  # and higher, split the string into pairs, e.g. `ABCD` => `AB`, `BC`, `CD`. Sum up
  # the counts per character for each of these pairs, then subtract 1 for each character
  # that was placed in 2 pairs (`B` and `C` from the previous example)
  (template.length - 1).times do |i|
    pair = template[i..(i + 1)]

    # Create a range that covers the contiguous block in the array for character counts
    # for a given pair and iteration
    start_index = ((steps * PAIRS.length) + PAIR_INDEXES[pair]) * CHARS.length
    end_index = start_index + CHARS.length - 1
    CHAR_COUNTS[start_index..end_index].each.with_index do |count, char_index|
      counts[char_index] += count
    end
    counts[CHAR_INDEXES[pair[0]]] -= 1 if i > 0
  end

  min, max = counts.minmax
  max - min
end

puts score(TEMPLATE, PART_1_STEPS)
puts score(TEMPLATE, PART_2_STEPS)
