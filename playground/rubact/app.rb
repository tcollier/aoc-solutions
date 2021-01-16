require 'ruby_figlet'

require_relative 'lib/box'
require_relative 'lib/screen'
require_relative 'lib/text_format'

class Application
  def initialize
    @end_at = Time.now + 15
  end

  def running?
    Time.now < @end_at
  end

  def draw(width, height, &block)
    settings = BoxSettings.new(
      width: 80,
      color: TextColor::BLUE.bright,
      bg_color: BgColor::YELLOW,
      border_style: BorderStyles::DOUBLE,
      border_settings: BorderSettings.new(bottom: true, top: true, left: true, right: true, color: TextColor::BLUE),
      align: TextAlign::CENTER,
      padding: BoxPadding.new(top: 1, bottom: 1, left: 3, right: 3),
      margin: AutoMargin.new(top: 3, bottom: 2)
    )
    Box.new(RubyFiglet::Figlet.new(Time.now.strftime("%H:%M:%S")).to_s, settings).draw(width, height, &block)
  end
end

Screen.run(30, Application.new)
