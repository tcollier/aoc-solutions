class Range
  def overlaps?(other)
    include?(other.min) || include?(other.max) || other.include?(min) || other.include?(max)
  end

  def small?
    min >= -50 && max <= 50
  end
end

class Region
  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  def small?
    x.small? && y.small? && z.small?
  end

  def size
    x.count * y.count * z.count
  end

  def overlaps?(other)
    x.overlaps?(other.x) && y.overlaps?(other.y) && z.overlaps?(other.z)
  end

  def -(other)
    return [self] unless overlaps?(other)
    parts = []
    parts << Region.new((other.x.max + 1)..x.max, y, z) if x.max > other.x.max
    parts << Region.new(x.min..(other.x.min - 1), y, z) if x.min < other.x.min
    mid_x = ([x.min, other.x.min].max)..([x.max, other.x.max].min)
    parts << Region.new(mid_x, (other.y.max + 1)..y.max, z) if y.max > other.y.max
    parts << Region.new(mid_x, y.min..(other.y.min - 1), z) if y.min < other.y.min
    mid_y = ([y.min, other.y.min].max)..([y.max, other.y.max].min)
    parts << Region.new(mid_x, mid_y, (other.z.max + 1)..z.max) if z.max > other.z.max
    parts << Region.new(mid_x, mid_y, z.min..(other.z.min - 1)) if z.min < other.z.min
    parts
  end

  protected

  attr_reader :x, :y, :z
end

part1_regions = []
part2_regions = []

$<.each.with_index do |line, index|
  match = line.match(/(on|off) x=(-?\d+..-?\d+),y=(-?\d+..-?\d+),z=(-?\d+..-?\d+)/)
  region = Region.new(
    eval(match[2]),
    eval(match[3]),
    eval(match[4])
  )
  if region.small?
    part1_regions = part1_regions.map { |r| r - region }.flatten
    part1_regions << region if match[1] == 'on'
  end
  part2_regions = part2_regions.map { |r| r - region }.flatten
  part2_regions << region if match[1] == 'on'
end

puts part1_regions.map(&:size).sum
puts part2_regions.map(&:size).sum
