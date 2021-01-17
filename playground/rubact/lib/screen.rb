require 'highline'
require 'tty-cursor'

require_relative 'text_format'

class Screen
  def initialize
    Signal.trap('SIGWINCH', proc { self.refresh_size! })
    @terminal = HighLine.new.terminal
    @cursor = TTY::Cursor
    refresh_size!
  end

  def self.run(refresh_rate_fps, application)
    screen = Screen.new
    begin
      while application.running?
        screen.draw(application)
        sleep(1.0 / refresh_rate_fps)
      end
    ensure
      screen.finalize
    end
  end

  def draw(application)
    print cursor.hide
    print cursor.move_to(0, 0)
    line_num = 0
    application.draw(width) do |lines|
      lines.split("\n").each do |line|
        screen_width = width + Ansi.hidden_width(line)
        trunc_line = line[0..screen_width - 1]
        print Ansi.close_formatting(trunc_line) + (' ' * (screen_width - trunc_line.length))
        line_num += 1
        break if line_num == height
      end
      break if line_num == height
    end
    if line_num < height
      print "\n"
      print cursor.clear_screen_down
    end
    STDOUT.flush
  end

  def finalize
    print Ansi.clear
    print cursor.show
    STDOUT.flush
  end

  protected

  def refresh_size!
    @width, @height = terminal.terminal_size
  end

  private

  attr_reader :cursor, :terminal, :width, :height
end
