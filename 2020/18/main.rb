require 'aoc_executor'

class Integer
  def /(other)
    self + other
  end

  def **(other)
    self + other
  end
end

part1_proc = Proc.new { |data| eval(data.chomp.gsub(/\+/, '/').gsub("\n", '+')) }
part2_proc = Proc.new { |data| eval(data.chomp.gsub(/\+/, '**').gsub("\n", '+')) }
executor = AocExecutor.new(
  File.read(File.join(File.dirname(__FILE__), 'input.txt')), part1_proc, part2_proc
)
executor.run(ARGV)
