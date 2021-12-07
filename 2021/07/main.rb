CURR = $<.gets.split(',').map(&:to_i)
def calc_opt(curr, cost_proc)
  optimal = 1.0 / 0
  (curr.min..curr.max).each do |attempt|
    opt = cost_proc[curr, attempt]
    optimal = opt if opt < optimal
  end
  optimal
end

part1_cost = -> curr, attempt { curr.map { |c| (c - attempt).abs }.sum }
puts calc_opt(CURR, curr.s)

part2_cost = -> curr, attempt { curr.map { |c| ((c - attempt).abs + 1) * (c - attempt).abs / 2 }.sum }
puts calc_opt(CURR, part2_cost)
