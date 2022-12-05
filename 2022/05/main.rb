#!/usr/bin/env ruby

input = $<.map(&:chomp)
NUM_STACKS = 9
STACKS_PT1 = Array.new(NUM_STACKS) { Array.new }
STACKS_PT2 = Array.new(NUM_STACKS) { Array.new }
tmp = []
while (next_row = input.shift.gsub(/\[|\]|/, '').gsub(/    /, ',').gsub(/ /, ','))[1] != '1' do
  tmp.unshift(next_row.split(',').map { _1 == '' ? nil : _1 })
end
while line = tmp.shift
  NUM_STACKS.times do |index|
    STACKS_PT1[index].push(line[index]) unless line[index].nil?
    STACKS_PT2[index].push(line[index]) unless line[index].nil?
  end
end

input.shift

input.map do |line|
  match = line.match(/move (\d+) from (\d+) to (\d+)/)
  num_crates, src, dest = [match[1].to_i, match[2].to_i - 1, match[3].to_i - 1]
  num_crates.times { STACKS_PT1[dest].push(STACKS_PT1[src].pop) }
  num_crates.times { tmp.push(STACKS_PT2[src].pop) }
  num_crates.times { STACKS_PT2[dest].push(tmp.pop) }
end

puts STACKS_PT1.map { _1.pop }.join
puts STACKS_PT2.map { _1.pop }.join
