require 'ruby_figlet'

require_relative 'lib/screen'
require_relative 'lib/ui'

class Application
  def initialize
    @end_at = Time.now + 15
  end

  def running?
    Time.now < @end_at
  end

  def draw(width, &block)
    outer_settings = UI::BoxSettings.new(
      color: UI::TextColor::BLUE.bright,
      bg_color: UI::BgColor::YELLOW,
      border_settings: UI::BorderSettings.new(color: UI::TextColor::BLACK),
      padding: UI::BoxPadding.new(top: 1, right: 2, bottom: 1, left: 2),
      margin: UI::BoxMargin.new(top: 1, right: 2, bottom: 1, left: 2)
    )
    inner_settings = UI::BoxSettings.new(
      color: UI::TextColor::RED.bright,
      bg_color: UI::BgColor::GREEN,
      border_settings: UI::BorderSettings.new(style: UI::BorderStyles::SOFT, color: UI::TextColor::RED.bright),
      align: UI::TextAlign::CENTER,
      padding: UI::BoxPadding.new(top: 1, right: 2, bottom: 1, left: 2),
      margin: UI::BoxMargin.new(top: 1, right: 3, bottom: 1, left: 2)
    )
    UI::Box.new(
      # UI::Box.new(RubyFiglet::Figlet.new(Time.now.strftime('%H:%M:%S')).to_s, inner_settings),
      UI::Box.new(Time.now.strftime('%H:%M:%S'), inner_settings),
      outer_settings
    ).draw(width, &block)
  end
end

Screen.run(30, Application.new)
