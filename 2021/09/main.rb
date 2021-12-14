require 'whirled_peas/animator/easing'

floor_map = FloorMap.new($<.map { _1.chomp.chars.map(&:to_i) })

BASINS = []

BASIN_MAP = Array.new(MAP.length) { Array.new(MAP[0].length) }
COLOR_MAP = Array.new(MAP.length) { Array.new(MAP[0].length) }

COLORS = (31..36).to_a + (91..96).to_a

class Timer
  def initialize(duration, num_frames)
    @duration = duration
    @num_frames = num_frames
    @curr_frame = 0
    @easing = WhirledPeas.const_get('Animator::Easing').new(:bezier)
    @prev = 0
  end

  def next_delay
    @curr_frame += 1
    curr = @duration * @easing.invert(@curr_frame.to_f / @num_frames)
    delay = curr - @prev
    @prev = curr
    delay
  end
end
TIMER = MAP.length < 30 ? Timer.new(3, 35) : Timer.new(10, 7459)

class Counter
  def initialize
    @cnt = 0
  end

  def inc
    @cnt += 1
  end

  def count
    @cnt
  end
end

COUNTER = Counter.new

def simplify_board
  curr_color = nil
  str = "\033[H\033[2J"
  COLOR_MAP.length.times do |row|
    str += "\n" if row > 0
    COLOR_MAP[row].length.times do |col|
      if curr_color.nil?
        str += "\033[#{COLOR_MAP[row][col]}m"
      elsif COLOR_MAP[row][col] != curr_color
        str += "\033[0m\033[#{COLOR_MAP[row][col]}m"
      end
      str += MAP[row][col].to_s
    end
  end
  str += "\033[0m\n"
end

def print_board(f)
  COUNTER.inc
  f.puts(TIMER.next_delay)
  puts "COUNTED: #{COUNTER.count}" if COUNTER.count % 100 == 0
  MAP.length.times do |row|
    MAP[row].length.times do |col|
      COLOR_MAP[row][col] = BASIN_MAP[row][col].nil? ? 90 : COLORS[BASIN_MAP[row][col] % COLORS.length]
    end
  end
  f.print(simplify_board)
end

def connect(row, col, index, f)
  return if MAP[row][col] == 9 || !BASIN_MAP[row][col].nil?
  BASIN_MAP[row][col] = index
  BASINS[index] += 1
  print_board(f)
  connect_four(row, col, index, f)
end

def connect_four(row, col, index, f)
  dirs = []
  dirs << [row - 1, col] if row > 0
  dirs << [row + 1, col] if row < MAP.length - 1
  dirs << [row, col - 1] if col > 0
  dirs << [row, col + 1] if col < MAP[row].length - 1
  dirs.shuffle.each { |dir| connect(dir[0], dir[1], index, f) }
end

points = []
BASIN_MAP.length.times do |row|
  BASIN_MAP[row].length.times do |col|
    points << row + col * 1i unless MAP[row][col] == 9
  end
end

File.open('animation.anm', 'w') do |f|
  f.puts MAP.length

  points.shuffle.each do |point|
    next unless BASIN_MAP[point.real][point.imag].nil?
    index = BASINS.length
    BASIN_MAP[point.real][point.imag] = index
    BASINS[index] = 1
    print_board(f)
    connect_four(point.real, point.imag, index, f)
  end
end
