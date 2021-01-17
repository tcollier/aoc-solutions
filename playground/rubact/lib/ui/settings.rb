module UI
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
  private_constant :BoxSpacing

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


  BorderStyle = Struct.new(
    :top_left, :top_horiz, :top_right, :left_vert, :right_vert, :bottom_left, :bottom_horiz, :bottom_right
  )

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
      width: nil,
      color: nil,
      bg_color: nil,
      bold: nil,
      underline: nil,
      border_settings: nil,
      margin: nil,
      padding: nil,
      align: nil
    )
      @width = width
      @color = color
      @bg_color = bg_color
      @bold = bold
      @underline = underline
      @border_settings = border_settings
      @margin = margin
      @padding = padding
      @align = align
    end

    def bold?
      @bold || false
    end

    def underline?
      @underline || false
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
        bold: @bold.nil? ? parent.bold : @bold,
        underline: @underline.nil? ? parent.underline : @underline,
        border_settings: @border_settings || parent.border_settings,
        margin: @margin || parent.margin,
        padding: @padding || parent.padding,
        align: @align || parent.align
      )
    end

    protected

    attr_reader :bold, :underline
  end
end
