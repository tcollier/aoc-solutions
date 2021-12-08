require 'set'

SEGS_TO_DIGIT = {
  'abcefg' => 0,
  'cf' => 1,
  'acdeg' => 2,
  'acdfg' => 3,
  'bcdf' => 4,
  'abdfg' => 5,
  'abdefg' => 6,
  'acf' => 7,
  'abcdefg' => 8,
  'abcdfg' => 9,
}

def map_segs(inputs)
  seg_map = {}
  segs_count_map = Hash.new { [] }
  occur_count_inv_map = Hash.new { 0 }
  count_map = inputs.each do |input|
    chars = input.chars
    segs_count_map[input.length] <<= Set.new(chars)
    chars.each do |char|
      occur_count_inv_map[char] += 1
    end
  end
  occur_count_map = occur_count_inv_map.map.with_object(Hash.new { Array.new }) do |(char, cnt), hash|
    hash[cnt] <<= char
  end
  seg_map[?a] = (segs_count_map[3][0] - segs_count_map[2][0]).first
  seg_map[?b] = occur_count_map[6][0]
  seg_map[?c] = (occur_count_map[8] - [seg_map[?a]]).first
  seg_map[?d] = (occur_count_map[7] & segs_count_map[4][0].to_a).first
  seg_map[?e] = occur_count_map[4][0]
  seg_map[?f] = occur_count_map[9][0]
  seg_map[?g] = (%w[a b c d e f g] - seg_map.values).first
  seg_map.invert
end

cnt_1 = 0
cnt_2 = 0
LINES = $<.map do |line|
  parts = line.split(' | ')
  inputs = parts[0].split
  seg_map = map_segs(inputs)
  raw_outputs = parts[1].split
  outputs = raw_outputs.map { |o| o.chars.map { |c| seg_map[c] }.sort.join }
  cnt_1 += outputs.count { |output| [2, 3, 4, 7].include?(output.length) }
  val = 0
  outputs.map do |output|
    val *= 10
    val += SEGS_TO_DIGIT[output]
  end
  cnt_2 += val
end

puts cnt_1
puts cnt_2
