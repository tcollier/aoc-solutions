#!/usr/bin/env ruby

input = $<.map(&:chomp)
label_line_num = input.index { _1[1] == '1' }
label_map = input[label_line_num].split(' ').map.with_index.with_object({}) { |(l, i), h| h[l] = i }
stacks_1 = Array.new(label_map.count) { Array.new }
stacks_2 = Array.new(label_map.count) { Array.new }
(label_line_num - 1).downto(0) do |line_num|
  row = input[line_num].gsub(/\[|\]|/, '').gsub(/    /, ',').gsub(/ /, ',').split(',').map { _1 == '' ? nil : _1 }
  label_map.count.times do |index|
    stacks_1[index].push(row[index]) unless row[index].nil?
    stacks_2[index].push(row[index]) unless row[index].nil?
  end
end
input[(label_line_num + 2)..-1].map do |line|
  match = line.match(/move (\d+) from (.+) to (.+)/)
  num_crates, src, dest = [match[1].to_i, match[2], match[3]]
  num_crates.times { stacks_1[label_map[dest]].push(stacks_1[label_map[src]].pop) }
  tmp = num_crates.times.map { stacks_2[label_map[src]].pop }
  num_crates.times { stacks_2[label_map[dest]].push(tmp.pop) }
end

puts stacks_1.map { _1.pop }.join
puts stacks_2.map { _1.pop }.join
