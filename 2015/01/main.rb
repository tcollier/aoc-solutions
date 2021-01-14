require 'aoc_executor'

part1_proc = Proc.new do |input|
  str = input[0].chomp
  while str !~ /^(.)\1{1,}$/
    str.gsub!(/\(\g<0>?\)/, '')
    str.gsub!(/\)\g<0>?\(/, '')
  end
  (-1) ** (str[0].ord - '('.ord) * str.length
end

part2_proc = Proc.new do |input|
  floor = 0
  answer = nil
  input[0].chars.find.with_index do |c, i|
    floor += (c == '(' ? 1 : -1)
    if floor < 0
      answer = i + 1
      break
    end
  end
  answer
end

executor = AocExecutor.new(
  File.readlines(File.join(File.dirname(__FILE__), 'input.txt')),
  part1_proc,
  part2_proc
)
executor.run(ARGV)
