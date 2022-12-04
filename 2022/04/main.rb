#!/usr/bin/env ruby

puts $<.map { _1.gsub(/(\d+)-(\d+)/, '(\1..\2).to_a') }
  .map { _1.split(',').map(&method(:eval)) }
  .sum { |(a, b)| [a, b].uniq.count(a & b) + (a & b).map { _1 / _1 }.uniq.first.to_i * 1i }
