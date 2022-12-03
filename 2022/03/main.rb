#!/usr/bin/env ruby

pr = ->(v) { v.ord - (v >= ?a ? ?` : ?&).ord }
bs = [?📛]
puts $<.map(&:chomp).map(&:chars).sum { |ch|
  bs = bs.length == 1 ? ch : bs & ch
  c = pr.call(bs.first) * 1i if bs.length == 1
  pr.call(ch.each_slice(ch.length >> 1).reduce((?A..?z).to_a) { _1 & _2 }.first) + (c || 0)
}
