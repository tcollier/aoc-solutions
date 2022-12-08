#!/usr/bin/env ruby

HEIGHTS = $<.map { _1.chomp.chars.map(&:to_i) }

def vs(height, rows, cols)
  num_shorter = rows.map { |row| cols.map { |col| HEIGHTS[row][col] } }.flatten.take_while { _1 < height }.length
  num_trees = [rows.count, cols.count].max
  [num_shorter < num_trees ? 0 : 1, [num_shorter + 1, num_trees].min]
end

answer = (1..(HEIGHTS.length - 2)).map do |row|
  (1..(HEIGHTS[row].length - 2)).map do |col|
    [
      vs(HEIGHTS[row][col], (row - 1).downto(0), [col]),
      vs(HEIGHTS[row][col], (row + 1).upto(HEIGHTS.length - 1), [col]),
      vs(HEIGHTS[row][col], [row], (col - 1).downto(0)),
      vs(HEIGHTS[row][col], [row], (col + 1).upto(HEIGHTS[row].length - 1)),
    ].reduce([0, 1]) do |acc, item|
      [[acc.first, item.first].max, acc.last * item.last]
    end
  end
end.flatten(1).reduce([(HEIGHTS.length - 1) * 2 + (HEIGHTS[0].length - 1) * 2, 0]) do |acc, item|
  [acc.first + item.first, [acc.last, item.last].max]
end

puts answer.join("\n")
