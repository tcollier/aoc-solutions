require_relative 'text_format'

module TextAlign
  LEFT = 1
  CENTER = 2
  RIGHT = 3
end

class BoxPadding
  attr_reader :left, :top, :right, :bottom

  def initialize(left: 0, top: 0, right: 0, bottom: 0)
    @left = left
    @top = top
    @right = right
    @bottom = bottom
  end
end

class BoxMargin
  attr_reader :left, :top, :right, :bottom

  def initialize(left: 0, top: 0, right: 0, bottom: 0)
    @left = left
    @top = top
    @right = right
    @bottom = bottom
  end

  def auto?
    false
  end
end

class AutoMargin
  attr_reader :top, :bottom

  def initialize(top: 0, bottom: 0)
    @top = top
    @bottom = bottom
  end

  def auto?
    true
  end
end


BorderStyle = Struct.new(:top_left, :top_horiz, :top_right, :left_vert, :right_vert, :bottom_left, :bottom_horiz, :bottom_right)

module BorderStyles
  BOLD = BorderStyle.new('┏', '━', '┓', '┃', '┃', '┗', '━', '┛')
  SOFT = BorderStyle.new('╭', '─', '╮', '│', '│', '╰', '─', '╯')
  DOUBLE = BorderStyle.new('╔', '═', '╗', '║', '║', '╚', '═', '╝')
end

class BorderSettings
  attr_reader :color

  def initialize(left: false, top: false, right: false, bottom: false, color: nil)
    @left = left
    @top = top
    @right = right
    @bottom = bottom
    @color = color
  end

  def left?
    @left
  end

  def top?
    @top
  end

  def right?
    @right
  end

  def bottom?
    @bottom
  end
end

class BoxSettings
  attr_reader :width, :color, :bg_color, :margin, :padding, :align, :border_style, :border_settings

  def initialize(
    width: nil, color: nil, bg_color: nil, border_style: BorderStyles::BOLD, border_settings: BorderSettings.new, margin: BoxSpacing.new, padding: BoxSpacing.new, align: TextAlign::LEFT
  )
    @width = width
    @color = color
    @bg_color = bg_color
    @border_style = border_style
    @border_settings = border_settings
    @margin = margin
    @padding = padding
    @align = align
  end
end

class Box
  PADDING = ' '
  MARGIN = ' '
  JUSTIFICATION = ' '

  def initialize(content, settings=BoxSettings.new)
    @content = content
    @settings = settings
    @content_width = 0
    @content.split("\n").each do |line|
      @content_width = line.length if line.length > @content_width
    end
    @width = @settings.width || @content_width
  end

  def draw(container_width, container_height, &block)
    draw_top(container_width, &block)
    lines = @content.split("\n").each do |line|
      draw_line(container_width, line, &block)
    end
    draw_bottom(container_width, &block)
  end

  private

  def draw_line(container_width, line, &block)
    yield left(container_width) +
      Ansi.format(JUSTIFICATION * left_just, [*@settings.bg_color]) +
      visible(line) +
      Ansi.format(JUSTIFICATION * right_just, [*@settings.bg_color]) +
      right(container_width)
  end

  def visible(line)
    if line.length <= @width
      v = line
    elsif @settings.align == TextAlign::LEFT
      v = line[0..@width - 1]
    elsif @settings.align == TextAlign::CENTER
      left_chop = (line.length - @width) / 2
      right_chop = line.length - @width - left_chop
      v = line[left_chop..-right_chop - 1]
    else
      v = line[-@width..-1]
    end
    Ansi.format(v, [*@settings.color, *@settings.bg_color])
  end

  def left(container_width)
    MARGIN * left_margin(container_width) +
      (@settings.border_settings.left? ? Ansi.format(@settings.border_style.left_vert, [*@settings.bg_color, *@settings.border_settings.color]) : '') +
      Ansi.format(PADDING * @settings.padding.left, [*@settings.bg_color])
  end

  def right(container_width)
    Ansi.format(PADDING * @settings.padding.right, [*@settings.bg_color]) +
      (@settings.border_settings.right? ? Ansi.format(@settings.border_style.right_vert, [*@settings.bg_color, *@settings.border_settings.color]) : '') +
      MARGIN * right_margin(container_width)
  end

  def left_margin(container_width)
    if @settings.margin.auto?
      (container_width - @width) / 2 - @settings.padding.left - (@settings.border_settings.left? ? 1 : 0)
    else
      @settings.margin.left
    end
  end

  def right_margin(container_width)
    if @settings.margin.auto?
      (container_width - @width) / 2 - @settings.padding.right - (@settings.border_settings.right? ? 1 : 0)
    else
      @settings.margin.right
    end
  end

  def left_just
    case @settings.align
    when TextAlign::LEFT
      0
    when TextAlign::CENTER
      [0, (@width - @content_width) / 2].max
    when TextAlign::RIGHT
      [0, @width - @content_width].max
    end
  end

  def right_just
    [0, @width - @content_width - left_just].max
  end

  def draw_horiz_border(container_width, start_corner, horizontal, end_corner, &block)
    yield MARGIN * left_margin(container_width) +
    Ansi.format(
        start_corner +
        horizontal * (@width + @settings.padding.left + @settings.padding.right) +
        end_corner,
        [*@settings.bg_color, *@settings.border_settings.color]
      ) +
      MARGIN * right_margin(container_width)
  end

  def draw_empty_margin(container_width, &block)
    yield MARGIN * (left_margin(container_width) +
      (@settings.border_settings.left? ? 1 : 0) +
      @settings.padding.left +
      @width +
      @settings.padding.right +
      (@settings.border_settings.right? ? 1 : 0) +
      right_margin(container_width))
  end

  def draw_top(container_width, &block)
    @settings.margin.top.times { draw_empty_margin(container_width, &block) }
    if @settings.border_settings.top?
      draw_horiz_border(
        container_width,
        @settings.border_settings.left? ? @settings.border_style.top_left : '',
        @settings.border_style.top_horiz,
        @settings.border_settings.right? ? @settings.border_style.top_right : '',
        &block
      )
    end
    @settings.padding.top.times do
      yield left(container_width) + Ansi.format(PADDING * @width, [*@settings.bg_color]) + right(container_width)
    end
  end

  def draw_bottom(container_width, &block)
    @settings.padding.bottom.times do
      yield left(container_width) + Ansi.format(PADDING * @width, [*@settings.bg_color]) + right(container_width)
    end
    if @settings.border_settings.bottom?
      draw_horiz_border(
        container_width,
        @settings.border_settings.left? ? @settings.border_style.bottom_left : '',
        @settings.border_style.bottom_horiz,
        @settings.border_settings.right? ? @settings.border_style.bottom_right : '',
        &block
      )
    end
    @settings.margin.bottom.times { draw_empty_margin(container_width, &block) }
  end
end
