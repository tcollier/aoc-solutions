ONE_TILE = $<.map { _1.chomp.chars.map(&:to_i) }
ALL_TILES = (ONE_TILE.length * 5).times.map do |row|
  (ONE_TILE[0].length * 5).times.map do |col|
    val = ONE_TILE[row % ONE_TILE.length][col % ONE_TILE[0].length] + row / ONE_TILE.length + col / ONE_TILE[0].length
    val = val - 9 while val > 9
    val
  end
end

class Heap
  def initialize
    @size = 0
    @items = []
  end

  def insert(row, col, dist)
    if @size == @items.length
      @items.append([row, col, dist])
    else
      @items[size] = [row, col, dist]
    end
    percolate_up(@size)
    @size += 1
  end

  def delete
    return if @size == 0
    value = @items[0]
    @items[0] = @items[@size - 1]
    @items[@size - 1] = nil
    @size -= 1
    percolate_down(0)
    @items.pop()
    value
  end

  def empty?
    @size == 0
  end

  def to_s
    "Heap<size: #{@size}, items: #{@items.inspect}>"
  end

  private

  def percolate_up(index)
    return if index == 0
    parent_index = (index + 1) / 2 - 1
    if @items[index].last < @items[parent_index].last
      temp = @items[index]
      @items[index] = @items[parent_index]
      @items[parent_index] = temp
      percolate_up(parent_index)
    end
  end

  def percolate_down(index)
    left_index = (index + 1) * 2 - 1
    return if left_index >= @size

    right_index = left_index + 1
    if right_index >= @size || @items[left_index].last < @items[right_index].last
      child_index = left_index
    else
      child_index = right_index
    end
    if @items[index].last >= @items[child_index].last
      temp = @items[index]
      @items[index] = @items[child_index]
      @items[child_index] = temp
      percolate_down(child_index)
    end
  end
end

def neighbors(grid, row, col)
  n = []
  n << [row - 1, col] if row > 0
  n << [row + 1, col] if row < grid.length - 1
  n << [row, col - 1] if col > 0
  n << [row, col + 1] if col < grid[0].length - 1
  n
end

def min_score(grid)
  pq = Heap.new
  pq.insert(0, 0, 0)
  visited = Array.new(grid.length * grid[0].length) { false }

  while !pq.empty?
    row, col, curr_score = pq.delete
    next if visited[row * grid[0].length + col]
    visited[row * grid[0].length + col] = true
    return curr_score if row == grid.length - 1 && col == grid[0].length - 1
    neighbors(grid, row, col).each do |(nrow, ncol)|
      next_score = curr_score + grid[nrow][ncol]
      pq.insert(nrow, ncol, next_score)
    end
  end
  return 1.0 / 0
end

puts min_score(ONE_TILE)
puts min_score(ALL_TILES)
