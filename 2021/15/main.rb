ONE_TILE = $<.map { _1.chomp.chars.map(&:to_i) }
ALL_TILES = (ONE_TILE.length * 5).times.map do |row|
  (ONE_TILE[0].length * 5).times.map do |col|
    val = ONE_TILE[row % ONE_TILE.length][col % ONE_TILE[0].length] + row / ONE_TILE.length + col / ONE_TILE[0].length
    val = val - 9 while val > 9
    val
  end
end

MIN_SCORES = Array.new(ALL_TILES.length) { Array.new(ALL_TILES[0].length) { 1.0 / 0 } }

queue = Queue.new
queue.push([0, 0, 0])
while !queue.empty?
  row, col, curr_score = queue.pop
  curr_score += ALL_TILES[row][col]
  next if curr_score >= MIN_SCORES[row][col]
  MIN_SCORES[row][col] = curr_score
  queue.push([row, col + 1, curr_score]) if col < ALL_TILES[0].count - 1
  queue.push([row + 1, col, curr_score]) if row < ALL_TILES.count - 1
  queue.push([row, col - 1, curr_score]) if col > 0
  queue.push([row - 1, col, curr_score]) if row > 0
end

puts MIN_SCORES[ONE_TILE.length - 1][ONE_TILE[0].length - 1] - ONE_TILE.first.first
puts MIN_SCORES[ALL_TILES.length - 1][ALL_TILES[0].length - 1] - ALL_TILES.first.first
