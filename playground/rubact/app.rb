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

  def draw(width, &block)
    outer_settings = BoxSettings.new(
      color: TextColor::BLUE.bright,
      bg_color: BgColor::YELLOW,
      border_settings: BorderSettings.new(color: TextColor::BLACK),
      padding: BoxPadding.new(top: 1, right: 2, bottom: 1, left: 2),
      margin: BoxMargin.new(top: 1, right: 2, bottom: 1, left: 2)
    )
    inner_settings = BoxSettings.new(
      color: TextColor::RED.bright,
      bg_color: BgColor::GREEN,
      border_settings: BorderSettings.new(style: BorderStyles::SOFT, color: TextColor::RED.bright),
      align: TextAlign::CENTER,
      padding: BoxPadding.new(top: 1, right: 2, bottom: 1, left: 2),
      margin: BoxMargin.new(top: 1, right: 3, bottom: 1, left: 2)
    )
    Box.new(
      # Box.new(RubyFiglet::Figlet.new(Time.now.strftime('%H:%M:%S')).to_s, inner_settings),
      Box.new(Time.now.strftime('%H:%M:%S'), inner_settings),
      outer_settings
    ).draw(width, &block)
  end
end

Screen.run(30, Application.new)
