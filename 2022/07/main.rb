#!/usr/bin/env ruby

class AocDir
  attr_reader :size

  PARENT_DIR = '..'

  def initialize(parent = nil)
    @contents = {}
    contents[PARENT_DIR] = parent if parent
    @size = 0
  end

  def all_sizes
    [size] + contents.select { |(k, _)| k != PARENT_DIR }.map { |_, v|  v.all_sizes }.flatten
  end

  def cd(name)
    contents[name]
  end

  def add_dir(name)
    contents[name] = AocDir.new(self)
  end

  def add_file(size)
    @size += size
    contents[PARENT_DIR].add_file(size) if contents.key?(PARENT_DIR)
  end

  private

  attr_reader :contents
end

curr_dir = root = AocDir.new
$<.first # '$ cd /' is not needed as we start the code in the root directory
$<.each do |line|
  case line.chomp.split(' ')
  in ['$', 'cd', next_dir]
    curr_dir = curr_dir.cd(next_dir)
  in ['dir', dir]
    curr_dir.add_dir(dir)
  in [size, _file]
    curr_dir.add_file(size.to_i)
  end
end

puts root.all_sizes.select { _1 <= 100000 }.sum
puts root.all_sizes.select { _1 >= 30000000 - (70000000 - root.size) }.sort.first

