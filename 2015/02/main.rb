require 'aoc_executor'

part1_proc = Proc.new do |input|
  total = 0
  input.each do |line|
    dims = line.split('x').map(&:to_i).sort
    total += 3 * dims[0] * dims[1] + 2 * dims[2] * (dims[0] + dims[1])
  end
  total
end

part2_proc = Proc.new do |input|
end

executor = AocExecutor.new(
  File.readlines(File.join(File.dirname(__FILE__), 'input.txt')),
  part1_proc,
  part2_proc
)
executor.run(ARGV)
