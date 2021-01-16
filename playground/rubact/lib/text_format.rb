module Ansi
  BOLD = 1
  UNDERLINE = 4

  BLACK = 30
  RED = 31
  GREEN = 32
  YELLOW = 33
  BLUE = 34
  MAGENTA = 35
  CYAN = 36
  WHITE = 37

  END_FORMATTING = 0

  FORMAT_REGEX = /\033\[\d+m/

  class << self
    def format(str, codes)
      if codes.length == 0
        str
      else
        start_formatting = codes.map(&method(:esc_seq)).join
        "#{start_formatting}#{str}#{esc_seq(END_FORMATTING)}"
      end
    end

    def clear
      esc_seq(END_FORMATTING)
    end

    private

    def esc_seq(code)
      "\033[#{code}m"
    end
  end
end

class Color
  BRIGHT_OFFSET = 60
  private_constant :BRIGHT_OFFSET

  def initialize(code, bright=false)
    @code = code
    @bright = bright
  end

  def bright?
    @bright
  end

  def bright
    bright? ? self : self.class.new(@code + BRIGHT_OFFSET, true)
  end

  def to_s
    @code.to_s
  end
end

class BgColor < Color
  BG_OFFSET = 10
  private_constant :BG_OFFSET

  BLACK = new(Ansi::BLACK + BG_OFFSET)
  RED = new(Ansi::RED + BG_OFFSET)
  GREEN = new(Ansi::GREEN + BG_OFFSET)
  YELLOW = new(Ansi::YELLOW + BG_OFFSET)
  BLUE = new(Ansi::BLUE + BG_OFFSET)
  MAGENTA = new(Ansi::MAGENTA + BG_OFFSET)
  CYAN = new(Ansi::CYAN + BG_OFFSET)
  WHITE = new(Ansi::WHITE + BG_OFFSET)
  GRAY = BLACK.bright
end

class TextColor < Color
  BLACK = new(Ansi::BLACK)
  RED = new(Ansi::RED)
  GREEN = new(Ansi::GREEN)
  YELLOW = new(Ansi::YELLOW)
  BLUE = new(Ansi::BLUE)
  MAGENTA = new(Ansi::MAGENTA)
  CYAN = new(Ansi::CYAN)
  WHITE = new(Ansi::WHITE)
  GRAY = BLACK.bright
end

module TextFormat
  BOLD = Ansi::BOLD
  UNDERLINE = Ansi::UNDERLINE
end
