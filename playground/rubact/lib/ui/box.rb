require_relative 'text_format'


DEBUG_SPACING = ARGV.include?('--debug-spacing')

module TextAlign
  LEFT = 1
  CENTER = 2
  RIGHT = 3
end

class BoxSpacing
  def initialize(left: nil, top: nil, right: nil, bottom: nil)
    @left = left
    @top = top
    @right = right
    @bottom = bottom
  end

  def left
    @left || 0
  end

  def top
    @top || 0
  end

  def right
    @right || 0
  end

  def bottom
    @bottom || 0
  end
end

class BoxPadding < BoxSpacing
end

class BoxMargin < BoxSpacing
  def auto?
    false
  end
end

class AutoMargin
  def initialize(top: nil, bottom: nil)
    @top = top
    @bottom = bottom
  end

  def auto?
    true
  end

  def top
    @top || 0
  end

  def bottom
    @bottom || 0
  end

  def left
    0
  end

  def right
    0
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

  def initialize(left: true, top: true, right: true, bottom: true, style: nil, color: nil)
    @left = left
    @top = top
    @right = right
    @bottom = bottom
    @style = style
    @color = color
  end

  def style
    @style || BorderStyles::BOLD
  end

  def color
    @color || BorderStyles::WHITE
  end

  NONE = BorderSettings.new(left: false, right: false, top: false, bottom: false)

  def left?
    @left == true
  end

  def top?
    @top == true
  end

  def right?
    @right == true
  end

  def bottom?
    @bottom == true
  end
end

class BoxSettings
  attr_reader :width, :color, :bg_color

  def initialize(
    width: nil, color: nil, bg_color: nil, border_settings: nil, margin: nil, padding: nil, align: nil
  )
    @width = width
    @color = color
    @bg_color = bg_color
    @border_settings = border_settings
    @margin = margin
    @padding = padding
    @align = align
  end

  def border_settings
    @border_settings || BorderSettings::NONE
  end

  def align
    @align || TextAlign::LEFT
  end

  def margin
    @margin || BoxMargin.new
  end

  def padding
    @padding || BoxPadding.new
  end

  def merge(parent)
    self.class.new(
      width: @width,
      color: @color || parent.color,
      bg_color: @bg_color || parent.bg_color,
      border_settings: @border_settings || parent.border_settings,
      margin: @margin || parent.margin,
      padding: @padding || parent.padding,
      align: @align || parent.align
    )
  end
end

class BoxWrapper
  attr_reader :preferred_width

  def initialize(text)
    @text = text
    @preferred_width = 0
    @text.split("\n").each do |line|
      @preferred_width = line.length if line.length > @preferred_width
    end
  end

  def draw(*)
    @text.split("\n").each do |line|
      yield line
    end
  end
end

class Box
  attr_reader :content, :settings, :content_width, :width

  def initialize(content, settings=BoxSettings.new)
    @content = content.respond_to?(:preferred_width) ? content : BoxWrapper.new(content)
    @settings = settings
    @content_width = @content.preferred_width
    @width = @settings.width || @content_width
  end

  def preferred_width
    settings.margin.left +
      (settings.border_settings.left? ? 1 : 0) +
      settings.padding.left +
      width +
      settings.padding.right +
      (settings.border_settings.right? ? 1 : 0) +
      settings.margin.right
  end

  def draw(container_width, parent_settings=BoxSettings.new, &block)
    BoxCanvas.new(self, container_width, settings, parent_settings).draw(&block)
  end
end

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
    @container_width = container_width
    @settings = settings.merge(parent_settings)
    @padding = PaddingCanvas.new(settings.padding, settings.bg_color, box.width)
    @border = BorderCanvas.new(settings.border_settings, settings.bg_color, @padding.width)
    @margin = MarginCanvas.new(settings.margin, parent_settings.bg_color, container_width, @border.width)
  end

  def draw(&block)
    draw_top(&block)
    box.content.draw(box.width, settings) do |line|
      draw_line(line, &block)
    end
    draw_bottom(&block)
  end

  private

  attr_reader :box, :container_width, :settings, :padding, :border, :margin

  def draw_line(line, &block)
    yield margin.left +
      border.left +
      padding.left +
      Ansi.format(JUSTIFICATION * left_just, [*settings.bg_color]) +
      Ansi.format(visible(line), [*settings.bg_color]) +
      Ansi.format(JUSTIFICATION * right_just, [*settings.bg_color]) +
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

  def left_just
    case settings.align
    when TextAlign::LEFT
      0
    when TextAlign::CENTER
      [0, (box.width - box.content_width) / 2].max
    when TextAlign::RIGHT
      [0, box.width - box.content_width].max
    end
  end

  def right_just
    [0, box.width - box.content_width - left_just].max
  end

  def draw_top(&block)
    margin.draw_top(&block)
    border.draw_top do |line|
      yield margin.left + line + margin.right
    end
    padding.draw_top do |line|
      yield margin.left + border.left + line + border.right + margin.right
    end
  end

  def draw_bottom(&block)
    padding.draw_bottom do |line|
      yield margin.left + border.left + line + border.right + margin.right
    end
    border.draw_bottom do |line|
      yield margin.left + line + margin.right
    end
    margin.draw_bottom(&block)
  end
end
