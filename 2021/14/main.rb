require 'set'

MAX_ITERS = 40
TEMPLATE = $<.gets.chomp

$<.gets
RULES = $<.map.with_object({}) do |line, hash|
  parts = line.chomp.split(' -> ')
  hash[parts[0]] = parts[1]
end

CHARS = Set.new(
  TEMPLATE.chars +
  RULES.keys.map(&:chars).flatten +
  RULES.values
).to_a.sort.map.with_index.with_object({}) { |(c, i), h| h[c] = i }

PAIRS = CHARS.keys.product(CHARS.keys).map(&:join).sort.map.with_index.with_object({}) { |(c, i), h| h[c] = i }

CACHE = Array.new((MAX_ITERS + 1) * CHARS.length ** 3)

C = -> { _1.chars.group_by(&:itself).map.with_object({}) { |(k, v), h| h[k] = v.count } }
I = -> { ((_1 * PAIRS.length) + _2) * CHARS.length + _3 }

PAIRS.each do |pair, pair_index|
  C[pair].each do |char, count|
    CACHE[I[0, pair_index, CHARS[char]]] = count
  end
end

(1..MAX_ITERS).each do |iter|
  PAIRS.each do |pair, pair_index|
    mid = RULES[pair]
    pair1 = pair[0] + mid
    pair2 = mid + pair[1]
    CHARS.each do |char, char_index|
      count1 = CACHE[I[iter - 1, PAIRS[pair1], char_index]]
      count2 = CACHE[I[iter - 1, PAIRS[pair2], char_index]]
      CACHE[I[iter, pair_index, char_index]] = (count1 || 0) + (count2 || 0) - (char == mid ? 1 : 0)
    end
  end
end

def score(template, iters)
  counts = [0] * CHARS.size
  (template.length - 1).times do |i|
    pair = template[i..(i + 1)]
    start_index = I[iters, PAIRS[pair], 0]
    CACHE[start_index..(start_index + CHARS.length - 1)].each.with_index do |count, char_index|
      counts[char_index] += count || 0
    end
    counts[CHARS[pair[0]]] -= 1 if i > 0
  end
  counts.select! { _1 > 0 }
  counts.sort!
  counts.last - counts.first
end

puts score(TEMPLATE, 10)
puts score(TEMPLATE, 40)
