num_rows = $<.gets.chomp.to_i
rows = nil
print "\033[H\033[J"
first = true
while (line = $<.gets)
  delay = line.chomp.to_f
  board = "\033[H"
  next_rows = []
  num_rows.times do |i|
    row = $<.gets
    row = row[7..] if i == 0
    next_rows << row
    board += ' ' + ((rows.nil? || row != rows[i]) ? row : "\033[E")
  end
  rows = next_rows
  print board
  $stdout.flush
  if first
    sleep(5)
    first = false
  else
    sleep(delay)
  end
end