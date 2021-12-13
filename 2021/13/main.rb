require 'set'
require_relative 'ocr'

dots = Set.new
while (line = $<.gets.chomp) != ''
  parts = line.split(',').map(&:to_i)
  dots.add(parts[0] + parts[1] * 1i)
end

folds = $<.map do |line|
  match = line.match(/fold along (x|y)=(\d+)/)
  match[2].to_i * (match[1] == ?x ? 1 : 1i)
end

def fold(dots, axis)
  Set.new(dots.map do |dot|
    if axis.real.between?(1, dot.real)
      2 * axis - dot.real + dot.imag * 1i
    elsif axis.imag.between?(1, dot.imag)
      2 * axis + dot.real - dot.imag * 1i
    else
      dot
    end
  end)
end

folds.each.with_index do |fold, index|
  dots = fold(dots, fold)
  puts dots.count if index == 0
end

puts Ocr.new(dots).to_s

