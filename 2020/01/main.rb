require 'set'

require 'aoc_executor'

def pair_with_sum(numbers, sum)
  others = Set.new(numbers[1..-1])
  numbers.each do |number|
    if others.include?(sum - number)
      return [number, sum - number]
    end
  end
  raise "No pair with sum #{sum} found"
end

def triplet_with_sum(numbers, sum)
  numbers.sort!
  (numbers.length - 2).times do |i|
    j = i + 1
    k = numbers.length - 1
    while j < k
      total = numbers[i] + numbers[j] + numbers[k]
      if total == sum
        return [numbers[i], numbers[j], numbers[k]]
      elsif total < sum
        j += 1
      else
        k -= 1
      end
    end
  end
  raise "No triplet with sum #{sum} found"
end

def a(m, n)
  q=p;m.sample(n).tap{|p|p.reduce(:+)==?<.ord.to_s(3).to_i&&q=p} until q;eval(q.join(?*))
end

def part1_ans(input)
  a(input, 2)
end

def part2_ans(input)
  a(input, 3)
end

part1_proc = Proc.new do |input|
  a(input, 2)
end

part2_proc = Proc.new do |input|
  a(input, 3)
end

executor = AocExecutor.new(
  File.readlines(File.join(File.dirname(__FILE__), 'input.txt')).map(&:to_i),
  part1_proc,
  part2_proc
)
executor.run(ARGV)
