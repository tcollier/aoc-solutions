require_relative 'settings'
require_relative 'text_format'

module UI
  DEBUG_SPACING = ARGV.include?('--debug-spacing')

  class MarginCanvas
    MARGIN = DEBUG_SPACING ? 'm' : ' '

    def initialize(margin, bg_color, container_width, contained_width)
      @margin = margin
      @bg_color = bg_color
      @container_width = container_width
      @contained_width = contained_width
    end

    def draw_top(&block)
      margin.top.times { draw_empty_margin(&block) }
    end

    def left
      format(left_margin_size)
    end

    def right
      format(right_margin_size)
    end

    def draw_bottom(&block)
      margin.top.times { draw_empty_margin(&block) }
    end

    private

    attr_reader :margin, :bg_color, :container_width, :contained_width

    def draw_empty_margin(&block)
      yield format(left_margin_size + contained_width + right_margin_size)
    end

    def format(width)
      Ansi.format(MARGIN * width, [*bg_color])
    end

    def left_margin_size
      if margin.auto?
        (container_width - contained_width) / 2
      else
        margin.left
      end
    end

    def right_margin_size
      if margin.auto?
        container_width - contained_width - left_margin
      else
        margin.right
      end
    end
  end

  class BorderCanvas
    attr_reader :width

    def initialize(border, bg_color, contained_width)
      @border = border
      @bg_color = bg_color
      @contained_width = contained_width
      @width = contained_width + (border.left? ? 1 : 0) + (border.right? ? 1 : 0)
    end

    def draw_top(&block)
      if border.top?
        yield horizontal_border(
          border.left? ? border.style.top_left : '',
          border.style.top_horiz,
          border.right? ? border.style.top_right : '',
        )
      end
    end

    def left
      format(border.style.left_vert) if border.left?
    end

    def right
      format(border.style.right_vert) if border.right?
    end

    def draw_bottom(&block)
      if border.bottom?
        yield horizontal_border(
          border.left? ? border.style.bottom_left : '',
          border.style.bottom_horiz,
          border.right? ? border.style.bottom_right : ''
        )
      end
    end

    private

    attr_reader :border, :bg_color, :contained_width

    def horizontal_border(start_corner, horizontal, end_corner)
      format(start_corner + horizontal * contained_width + end_corner)
    end

    def format(str)
      Ansi.format(str, [*bg_color, *border.color])
    end
  end

  class PaddingCanvas
    PADDING = DEBUG_SPACING ? 'p' : ' '

    attr_reader :width

    def initialize(padding, bg_color, contained_width)
      @padding = padding
      @bg_color = bg_color
      @contained_width = contained_width
      @width = contained_width + padding.left + padding.right
    end

    def draw_top(&block)
      padding.top.times do
        yield format(padding.left + contained_width + padding.right)
      end
    end

    def left
      format(padding.left)
    end

    def right
      format(padding.right)
    end

    def draw_bottom(&block)
      padding.bottom.times do
        yield format(padding.left + contained_width + padding.right)
      end
    end

    private

    attr_reader :padding, :bg_color, :contained_width

    def format(width)
      Ansi.format(PADDING * width, [*bg_color])
    end
  end

  class BoxCanvas
    JUSTIFICATION = DEBUG_SPACING ? 'j' : ' '

    def initialize(box, container_width, settings, parent_settings)
      @box = box
      @settings = settings.merge(parent_settings)
      @padding = PaddingCanvas.new(@settings.padding, @settings.bg_color, box.width)
      @border = BorderCanvas.new(@settings.border_settings, @settings.bg_color, @padding.width)
      @margin = MarginCanvas.new(@settings.margin, parent_settings.bg_color, container_width, @border.width)
    end

    def draw(&block)
      margin.draw_top(&block)
      border.draw_top { |line| yield margin.left + line + margin.right }
      padding.draw_top { |line| yield margin.left + border.left + line + border.right + margin.right }
      box.content.draw(box.width, settings) { |line| draw_content_line(line, &block) }
      padding.draw_bottom { |line| yield margin.left + border.left + line + border.right + margin.right }
      border.draw_bottom { |line| yield margin.left + line + margin.right }
      margin.draw_bottom(&block)
    end

    private

    attr_reader :box, :settings, :padding, :border, :margin

    def draw_content_line(line, &block)
      yield margin.left +
        border.left +
        padding.left +
        justify(line) +
        padding.right +
        border.right +
        margin.right
    end

    def visible(line)
      total_width = box.width + Ansi.hidden_width(line)
      if line.length <= total_width
        line
      elsif settings.align == TextAlign::LEFT
        line[0..total_width - 1]
      elsif settings.align == TextAlign::CENTER
        left_chop = (line.length - total_width) / 2
        right_chop = line.length - total_width - left_chop
        line[left_chop..-right_chop - 1]
      else
        line[-box.width..-1]
      end
    end

    def justify(line)
      ljust = case settings.align
      when TextAlign::LEFT
        0
      when TextAlign::CENTER
        [0, (box.width - box.content_width) / 2].max
      when TextAlign::RIGHT
        [0, box.width - box.content_width].max
      end
      rjust = [0, box.width - box.content_width - ljust].max
      Ansi.format(JUSTIFICATION * ljust, [*settings.bg_color]) +
        visible(line) +
        Ansi.format(JUSTIFICATION * rjust, [*settings.bg_color])
    end
  end
end
