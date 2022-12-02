#!/usr/bin/env ruby

SCORES = {
  'X' => {
    'A' => 4 + 3i,
    'B' => 1 + 1i,
    'C' => 7 + 2i,
  },
  'Y' => {
    'A' => 8 + 4i,
    'B' => 5 + 5i,
    'C' => 2 + 6i,
  },
  'Z' => {
    'A' => 3 + 8i,
    'B' => 9 + 9i,
    'C' => 6 + 7i,
  },
}

puts $<.map { SCORES[_1[-2]][_1[0]] }.reduce(:+)
