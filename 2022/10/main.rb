#!/usr/bin/env ruby
require 'set'

CHARS = {
  6922137 => 'A',
  15329694 => 'B',
  3215766 => 'J',
  10144425 => 'K',
  15310505 => 'R',
  15803535 => 'Z',
}

MISSING_CODES = Set.new
def missing_char(code, pixels)
  if !MISSING_CODES.include?(code)
    MISSING_CODES << code
    puts "Add #{code} to CHARS map"
    pixels.each { puts _1.map { |c| c == 1 ? ?█ : ' ' }.join }
    puts
  end
  ?_
end

def read_char(pixels)
  code = Integer(pixels.flatten.join, 2)
  CHARS[code] || missing_char(code, pixels)
end

def read_word(pixels)
  (pixels.first.length / 5).times.map do |index|
    start = index * 5
    read_char(pixels.map { _1[start..(start + 3)]})
  end.join
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
puts read_word(pixels.each_slice(40))
