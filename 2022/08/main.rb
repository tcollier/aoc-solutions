#!/usr/bin/env ruby


HEIGHTS = $<.map { |line| line.chomp.chars.map(&:to_i) }
VISIBLE = Array.new(HEIGHTS.length) { Array.new(HEIGHTS[0].length) { false } }
# SCENIC_SCORES = Array.new(HEIGHTS.length) { Array.new(HEIGHTS[0].length) { 0 } }

HEIGHTS.length.times do |row|
  max_height = -1
  HEIGHTS[row].length.times do |col|
    if HEIGHTS[row][col] > max_height
      VISIBLE[row][col] = true
      max_height = HEIGHTS[row][col]
    end
  end
  max_height = -1
  (HEIGHTS[row].length - 1).downto(0).each do |col|
    if HEIGHTS[row][col] > max_height
      VISIBLE[row][col] = true
      max_height = HEIGHTS[row][col]
    end
  end
end
HEIGHTS[0].length.times do |col|
  max_height = -1
  HEIGHTS.length.times do |row|
    if HEIGHTS[row][col] > max_height
      VISIBLE[row][col] = true
      max_height = HEIGHTS[row][col]
    end
  end
  max_height = -1
  (HEIGHTS.length - 1).downto(0).each do |row|
    if HEIGHTS[row][col] > max_height
      VISIBLE[row][col] = true
      max_height = HEIGHTS[row][col]
    end
  end
end

puts VISIBLE.sum { |line| line.count { _1 } }

max_scenic_score = 0
(1..(HEIGHTS.length - 2)).each do |row|
  (1..(HEIGHTS[row].length - 2)).each do |col|
    up_score = down_score = left_score = right_score = 0
    (row - 1).downto(0).each do |view_row|
      up_score += 1
      break if HEIGHTS[view_row][col] >= HEIGHTS[row][col]
    end
    (row + 1).upto(HEIGHTS.length - 1).each do |view_row|
      down_score += 1
      break if HEIGHTS[view_row][col] >= HEIGHTS[row][col]
    end
    (col - 1).downto(0).each do |view_col|
      left_score += 1
      break if HEIGHTS[row][view_col] >= HEIGHTS[row][col]
    end
    (col + 1).upto(HEIGHTS[row].length - 1).each do |view_col|
      right_score += 1
      break if HEIGHTS[row][view_col] >= HEIGHTS[row][col]
    end
    scenic_score = up_score * left_score * down_score * right_score
    max_scenic_score = scenic_score if scenic_score > max_scenic_score
  end
end
puts max_scenic_score
