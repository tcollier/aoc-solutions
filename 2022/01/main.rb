#!/usr/bin/env ruby

ELF_CALORIES = [0]
elf_index = 0
$<.each do |line|
  chomped = line.chomp
  if chomped == ""
    elf_index += 1
    ELF_CALORIES << 0
  else
    ELF_CALORIES[elf_index] += Integer(chomped)
  end
end
puts ELF_CALORIES.max
puts ELF_CALORIES.sort.reverse[0..2].sum
