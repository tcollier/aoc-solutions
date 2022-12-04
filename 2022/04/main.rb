#!/usr/bin/env ruby

puts $<.map { _1.gsub(/(\d+)-(\d+)/, '(\1..\2).to_a') }
  .map { _1.split(',').map(&method(:eval)) }
  .sum { |(a, b)| [a, b].uniq.count(a & b) + (a & b).map { 1i }.uniq.sum }
