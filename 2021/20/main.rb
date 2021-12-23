class Complex
  alias :x :real
  alias :y :imag
end

TRANSFORMATIONS = $<.gets.chomp.chars.map { _1 == '#' ? 1 : 0 }
$<.gets

INITIAL_BOARD = $<.each.with_index.with_object(Hash.new(0)) do |(line, row_index), hash|
  line.chomp.chars.each.with_index do |char, col_index|
    hash[col_index + row_index * 1i] = char == '#' ? 1 : 0
  end
end

def minmax(board)
  min_x = min_y = 1.0 / 0
  max_x = max_y = -1.0 / 0
  board.keys.each do |cell|
    min_x = cell.x if cell.x < min_x
    max_x = cell.x if cell.x > max_x
    min_y = cell.y if cell.y < min_y
    max_y = cell.y if cell.y > max_y
  end
  [min_x + min_y * 1i, max_x + max_y * 1i]
end

def print_board(board)
  puts board.count
  min, max = minmax(board)
  (min.y..max.y).each do |row_index|
    (min.x..max.x).each do |col_index|
      cell = col_index + row_index * 1i
      print board[cell] == 1 ? '#' : '.'
    end
    puts
  end
  puts
end

def transform(board, transformations)
  next_board = Hash.new(board.default == 0 ? transformations.first : transformations.last)
  border = 2
  min, max = minmax(board)
  ((min.y - border)..(max.y + border)).each do |row_index|
    ((min.x - border)..(max.x + border)).each do |col_index|
      cell = col_index + row_index * 1i
      lookup = 0
      9.times do |i|
        lookup <<= 1
        lookup += board[cell + (i % 3 - 1) + (i / 3 - 1) * 1i]
      end
      next_board[cell] = transformations[lookup]
    end
  end
  next_board
end

def count_lit(board, min, max)
  count = 0
  (min.y..max.y).each do |row_index|
    (min.x..max.x).each do |col_index|
      count += board[col_index + row_index * 1i]
    end
  end
  count
end

board = INITIAL_BOARD
min, max = minmax(INITIAL_BOARD)
2.times do
  board = transform(board, TRANSFORMATIONS)
  min -= 1 + 1i
  max += 1 + 1i
end
puts count_lit(board, min, max)

48.times do
  board = transform(board, TRANSFORMATIONS)
  min -= 1 + 1i
  max += 1 + 1i
end
puts count_lit(board, min, max)
