#!/usr/bin/env ruby

SCORES = {
  'X' => {
    'A' => [4, 3],
    'B' => [1],
    'C' => [7, 2],
  },
  'Y' => {
    'A' => [8, 4],
    'B' => [5],
    'C' => [2, 6],
  },
  'Z' => {
    'A' => [3, 8],
    'B' => [9],
    'C' => [6, 7],
  },
}
{
  'X' => 1, 'Y' => 5, 'Z' => 9,

}

scores = [0, 0]
$<.each do |line|
  match = line.chomp.match(/(A|B|C) (X|Y|Z)/)
  scores[0] += SCORES[match[2]][match[1]].first
  scores[1] += SCORES[match[2]][match[1]].last
end
puts scores.join("\n")
