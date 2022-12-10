#!/usr/bin/env ruby

CHARS = {
  6922137 => 'A',
  3215766 => 'J',
  10144425 => 'K',
  15310505 => 'R',
  15803535 => 'Z',
}

def read_word(pixels)
  (pixels.first.length / 5).times.map do |index|
    start = index * 5
    CHARS[Integer(pixels.map { _1[start..(start + 3)]}.flatten.join, 2)]
  end
end

cmds = $<.map do |line|
  case line.chomp.split(' ')
  in ['noop']
    0
  in ['addx', val]
    [0, Integer(val)]
  end
end.flatten
regx = 1
strengths = 0
pixels = cmds.map.with_index do |val, pixel|
  cycle = pixel + 1
  strengths += cycle * regx if cycle % 40 == 20
  char = ((regx - 1)..(regx + 1)).include?(pixel % 40) ? 1 : 0
  regx += val
  char
end
puts strengths
puts read_word(pixels.each_slice(40)).join
