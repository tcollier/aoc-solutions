require 'set'

# Keys are alphabetized list of segments used to make the digit, values
# are the digit. The keys are formatted with extra characters that are
# stripped out so that the list of values appears as a grid in code.
SEGS_TO_DIGIT = {                     # v-- number of segments per digit
  'a-b-c- -e-f-g'.tr('- ', '') => 0,  # 6
  ' - -c- - -f- '.tr('- ', '') => 1,  # 2
  'a- -c-d-e- -g'.tr('- ', '') => 2,  # 5
  'a- -c-d- -f-g'.tr('- ', '') => 3,  # 5
  ' -b-c-d- -f- '.tr('- ', '') => 4,  # 4
  'a-b- -d- -f-g'.tr('- ', '') => 5,  # 5
  'a-b- -d-e-f-g'.tr('- ', '') => 6,  # 6
  'a- -c- - -f- '.tr('- ', '') => 7,  # 3
  'a-b-c-d-e-f-g'.tr('- ', '') => 8,  # 7
  'a-b-c-d- -f-g'.tr('- ', '') => 9,  # 6
}
#  8 6 8 7 4 9 7
#  ^--- number of digits each segment appears in (i.e. segment  'a' appears
#       in 8 digits--all but '1' and '4')

def map_segs(inputs)
  seg_map = {}
  segments_per_digit = Hash.new { [] }
  occur_count_inv_map = Hash.new { 0 }
  count_map = inputs.each do |input|
    chars = input.chars
    segments_per_digit[input.length] <<= Set.new(chars)
    chars.each do |char|
      occur_count_inv_map[char] += 1
    end
  end
  digits_per_segment = occur_count_inv_map.map.with_object(Hash.new { Array.new }) do |(char, cnt), hash|
    hash[cnt] <<= char
  end
  seg_map[?a] = (segments_per_digit[3][0] - segments_per_digit[2][0]).first
  seg_map[?b] = digits_per_segment[6][0]
  seg_map[?c] = (digits_per_segment[8] - [seg_map[?a]]).first
  seg_map[?d] = (digits_per_segment[7] & segments_per_digit[4][0].to_a).first
  seg_map[?e] = digits_per_segment[4][0]
  seg_map[?f] = digits_per_segment[9][0]
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
