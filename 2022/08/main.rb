#!/usr/bin/env ruby

HEIGHTS = $<.map { _1.chomp.chars.map(&:to_i) }

num_visible = (HEIGHTS.length - 1) * 2 + (HEIGHTS[0].length - 1) * 2
max_scenic_score = 0

vs = -> (height, rows, cols) do
  shorter = rows.map { |row| cols.map { |col| [row, col] } }.flatten(1).take_while do |pos|
    HEIGHTS[pos.first][pos.last] < height
  end
  num_trees = [rows.count, cols.count].max
  [shorter.length == num_trees, [shorter.length + 1, num_trees].min]
end

(1..(HEIGHTS.length - 2)).each do |row|
  (1..(HEIGHTS[row].length - 2)).each do |col|
    result = [
      vs.call(HEIGHTS[row][col], (row - 1).downto(0), [col]),
      vs.call(HEIGHTS[row][col], (row + 1).upto(HEIGHTS.length - 1), [col]),
      vs.call(HEIGHTS[row][col], [row], (col - 1).downto(0)),
      vs.call(HEIGHTS[row][col], [row], (col + 1).upto(HEIGHTS[row].length - 1)),
    ].reduce([false, 1]) do |acc, item|
      [acc.first || item.first, acc.last * item.last]
    end
    num_visible += 1 if result.first
    max_scenic_score = result.last if result.last > max_scenic_score
  end
end

puts num_visible
puts max_scenic_score
