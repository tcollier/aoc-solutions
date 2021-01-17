require_relative 'settings'

module UI
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
end
