num_rows = $<.gets.chomp.to_i
while (line = $<.gets)
  delay = line.chomp.to_f
  board = ''
  num_rows.times do
    board += $<.gets
  end
  print board
  $stdout.flush
  puts delay
  sleep(delay)
end