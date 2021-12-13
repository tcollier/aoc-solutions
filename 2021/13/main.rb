require 'set'
require_relative 'ocr'

while (dots ||= Set.new) && (line = $<.gets.chomp) != ''
  dots.add(line.split(',').map(&:to_i).zip([1, 1i]).map{ _1 * _2 }.inject(:+))
end

folds = $<.map { eval(_1.gsub(/fold along (x|y)=(\d+)/, '\2\1').tr('xy', ' i')) }

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

