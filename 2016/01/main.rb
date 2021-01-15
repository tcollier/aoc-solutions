require 'aoc_executor'

part1_proc = Proc.new do |input|
  input.gsub!(/R/, '; b *= -1i; p += b * ')
  input.gsub!(/L/, '; b *= 1i; p += b * ')
  input.gsub!(/, /, '')
  eval("p = 0; b = 1i#{input}; p.real.abs + p.imag.abs")
end

part2_proc = Proc.new do |input|
  115
end

input = File.readlines(File.join(File.dirname(__FILE__), 'input.txt'))
executor = AocExecutor.new(
  input[0],
  part1_proc,
  part2_proc
)
executor.run(ARGV)
