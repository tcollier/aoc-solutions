started_at = Time.now
P1_SCORES = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}

p1_score = 0
p2_scores = []

$<.map do |line|
  prev_size = line.length
  curr = line.chomp
  while prev_size > curr.size
    prev_size = curr.length
    curr.gsub!(/\(\)|{}|\[\]|<>/, '')
  end
  if /\)|}|\]|>/ =~ curr
    p1_score += P1_SCORES[$~[0]]
  else
    p2_scores << curr.reverse.tr('{(<[', '3142').to_i(5)
  end
end
puts p1_score;
puts p2_scores.sort[p2_scores.length / 2]
puts Time.now - started_at