p1_pos, p2_pos = if ARGV.last == 'sample'
  [4, 8]
else
  [9, 10]
end

class DeterministicDie
  attr_reader :num_rolls

  def initialize(num_sides)
    @num_sides = num_sides
    @num_rolls = 0
  end

  def roll
    @num_rolls += 1
    (@num_rolls - 1) % @num_sides + 1
  end
end

def next_pos(pos, score)
  (pos + score - 1) % 10 + 1
end

def play_warm_up(die, winning_score, p1_pos, p2_pos)
  p1_score = p2_score = 0
  while true
    p1_pos = next_pos(p1_pos, 3.times.map { die.roll }.sum)
    p1_score += p1_pos
    break if p1_score >= winning_score
    p2_pos = next_pos(p2_pos, 3.times.map { die.roll }.sum)
    p2_score += p2_pos
    break if p2_score >= winning_score
  end
  [p1_score, p2_score].min * die.num_rolls
end

puts play_warm_up(DeterministicDie.new(100), 1000, p1_pos, p2_pos)

OUTCOMES = {
  3 => 1,
  4 => 3,
  5 => 6,
  6 => 7,
  7 => 6,
  8 => 3,
  9 => 1,
}

class Turn
  def initialize(p1_pos, p2_pos, p1_score, p2_score, p1_turn, num_universes)
    @p1_pos = p1_pos
    @p2_pos = p2_pos
    @p1_score = p1_score
    @p2_score = p2_score
    @p1_turn = p1_turn
    @num_universes = num_universes
  end

  def count_wins
    if p1_score >= 21
      [num_universes, 0]
    elsif p2_score >= 21
      [0, num_universes]
    else
      p1_total_wins = p2_total_wins = 0
      OUTCOMES.each do |roll, freq|
        p1_wins, p2_wins = if p1_turn
          next_p1_pos = next_pos(p1_pos, roll)
          Turn.new(next_p1_pos, p2_pos, p1_score + next_p1_pos, p2_score, false, num_universes * freq).count_wins
        else
          next_p2_pos = next_pos(p2_pos, roll)
          Turn.new(p1_pos, next_p2_pos, p1_score, p2_score + next_p2_pos, true, num_universes * freq).count_wins
        end
        p1_total_wins += p1_wins
        p2_total_wins += p2_wins
      end
      [p1_total_wins, p2_total_wins]
    end
  end

  attr_reader :p1_pos, :p2_pos, :p1_score, :p2_score, :p1_turn, :num_universes
end

puts Turn.new(p1_pos, p2_pos, 0, 0, true, 1).count_wins.max

