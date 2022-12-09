#!/usr/bin/env ruby
require 'set'

DIRS = { 'R' => 1, 'L' => -1, 'D' => -1i, 'U' => 1i }
FOLLOWS = {
  -2 + 2i => -1 + 1i, -1 + 2i => -1 + 1i, 0 + 2i => 0 + 1i, 1 + 2i => 1 + 1i, 2 + 2i => 1 + 1i,
  -2 + 1i => -1 + 1i, -1 + 1i =>  0 + 0i, 0 + 1i => 0 + 0i, 1 + 1i => 0 + 0i, 2 + 1i => 1 + 1i,
  -2 + 0i => -1 + 0i, -1 + 0i =>  0 + 0i, 0 + 0i => 0 + 0i, 1 + 0i => 0 + 0i, 2 + 0i => 1 + 0i,
  -2 - 1i => -1 - 1i, -1 - 1i =>  0 + 0i, 0 - 1i => 0 + 0i, 1 - 1i => 0 + 0i, 2 - 1i => 1 - 1i,
  -2 - 2i => -1 - 1i, -1 - 2i => -1 - 1i, 0 - 2i => 0 - 1i, 1 - 2i => 1 - 1i, 2 - 2i => 1 - 1i
}
head = 0 + 0i
tails = Array.new(9) { head }
first_tail = Set.new([tails.first])
last_tail = Set.new([tails.last])
$<.map(&:chomp)
  .map {  _1.match(/(R|L|D|U) (\d+)/) }
  .map { |match| Integer(match[2]).times.map {DIRS[match[1]] } }
  .flatten
  .each do |dir|
    head += dir
    leader = head
    tails = tails.map do |tail|
      (tail + FOLLOWS[leader - tail + 0i]).tap { leader = _1 }
    end
    first_tail.add(tails.first + 0i)
    last_tail.add(tails.last + 0i)
  end
puts first_tail.count
puts last_tail.count
