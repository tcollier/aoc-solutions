
P1_SCORES = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}

p1_score = 0
p2_scores = []

LINES = $<.map(&:chomp)
CLOSED_REGEX = /\(\)|{}|\[\]|<>/

def p2_score(scores)
  scores.length == 0 ? 'n/a' : scores[scores.length / 2]
end
`tput civis`
[LINES[2]].each do |line|
  print "\033[H\033[2J\033[25l"
  puts "part 1: #{p1_score}"
  puts "part 2: #{p2_score(p2_scores)}"
  puts
  print line
  $stdout.flush
  while index = CLOSED_REGEX =~ line
    sleep(0.05)
    print "\033[4;#{index + 1}H\033[32m#{line[index..(index + 1)]}\033[0m"

    sleep(0.4)
    print "\033[4;#{index + 1}H\033[42m  \033[0m"

    line.sub!(CLOSED_REGEX, '  ')
    sleep(0.10)
    print "\033[4;1H\033[2K#{line}\033[4;#{index + 1}\033[42m \033[0m"

    line.sub!(/  /, ' ')
    sleep(0.05)
    print "\033[4;1H\033[2K#{line}\033[4;#{index + 1}\033[42m \033[0m"

    line.sub!(/ /, '')
    sleep(0.10)
    print "\033[4;1H\033[2K#{line}"
  end

  sleep(0.25)
  if corrupt_index = /\)|}|\]|>/ =~ line
    print "\033[3;1H\033[31mINVALID: +#{P1_SCORES[line[currupt_index]]}\033[0m"
    print "\033[4;#{corrupt_index + 1}H\033[31m#{line[corrupt_index]}\033[0m"
  else
    print "\033[3;1H\033[32mVALID: #{10}\033[0m"
  end
  sleep(1)
end
`tput cvvis`

# $<.map do |line|
#   prev_size = line.length
#   curr = line.chomp
#   while prev_size > curr.size
#     prev_size = curr.length
#     curr.gsub!(/\(\)|{}|\[\]|<>/, '')
#   end
#   if /\)|}|\]|>/ =~ curr
#     p1_score += P1_SCORES[$~[0]]
#   else
#     p2_scores << curr.reverse.tr('{|(<[', '3.142').to_i(5)
#   end
# end
# puts p1_score;
# puts p2_scores.sort[p2_scores.length >> 1]
# puts Time.now - started_at


puts