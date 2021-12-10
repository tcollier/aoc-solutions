started_at = Time.now
corruption_score = 0
PAIRS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}
CORRUPTION_SCORES = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}
VALID_SCORES = {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4
}
valid_scores = []
$<.each do |line|
  stack = []
  valid = true
  line.chomp.chars.each do |char|
    if PAIRS.keys.include?(char)
      stack.push(char)
    else
      opener = stack.pop
      unless PAIRS[opener] == char
        corruption_score += CORRUPTION_SCORES[char]
        valid = false
        break
      end
    end
  end
  valid_score = 0
  while char = stack.pop
    valid_score *= 5
    valid_score += VALID_SCORES[char]
  end
  valid_scores << valid_score if valid
end
puts corruption_score
puts valid_scores.sort[valid_scores.length / 2]
puts Time.now - started_at