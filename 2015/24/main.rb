#!/usr/bin/env ruby

$<.chunk { _1 != "\n" }
  .select(&:first)
  .map(&:last)
  .map { _1.sum(&:to_i) }
  .sort
  .tap { p _1.last }
  .tap { p _1.last(3).sum }
