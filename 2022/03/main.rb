#!/usr/bin/env ruby

def pr(v)
  v.ord - (v >= ?a ? ?` : ?&).ord
end
bs = [?0]
puts $<.map(&:chomp).map(&:chars).sum { |ch|
  bs = bs.length == 1 ? ch : bs & ch
  c = pr(bs.first) * 1i if bs.length == 1
  pr(ch.each_slice(ch.length >> 1).reduce((?A..?z).to_a) { _1 & _2 }.first) + (c || 0)
}
