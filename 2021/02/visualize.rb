require 'whirled_peas'

WhirledPeas.register_theme(:under_the_sea) do |theme|
  theme.bg_color = :bright_blue
  theme.color = :yellow
end

class TemplateFactory
  SUBMARINE = <<-EOS
                open(
                ?d+
              'ay1.t'\\
 'xt'        ).map{|x|
  x.to_i}.tap{|q|$l=q};p$l.
each_cons(2).count{|a,b|a<b};
p$l.each_cons(03).map(&:sum).
  each_cons(2).count{|a,b|a<
 b};    puts('2021: Day1!')
EOS

  def build(frame, args)
    position = args[:position].to_c
    command = args[:command] || 'n/a'

    WhirledPeas.template(:under_the_sea) do |composer, settings|
      settings.flow = :t2b

      composer.add_box do |title, settings|
        settings.align = :center
        settings.width = 120

        title.add_text do |_, settings|
          settings.bold = true
          settings.title_font = :graceful
          'AoC 2021 Day 2'
        end
      end

      composer.add_box do |info, settings|
        settings.flow = :l2r
        settings.bold = true

        info.add_grid do |_, settings|
          settings.set_margin(left: 4)
          settings.num_cols = 2
          settings.full_border
          settings.set_padding(horiz: 1)
          settings.width = 9
          settings.align = :right

          ['Command  ', command]
        end
        info.add_grid do |_, settings|
          settings.set_margin(left: 4)
          settings.num_cols = 2
          settings.full_border
          settings.set_padding(horiz: 1)
          settings.width = 9
          settings.align = :right

          ['Position ', position.real]
        end
        info.add_grid do |_, settings|
          settings.set_margin(left: 4)
          settings.num_cols = 2
          settings.full_border
          settings.set_padding(horiz: 1)
          settings.width = 9
          settings.align = :right

          ['Depth    ', position.imag]
        end
        info.add_grid do |_, settings|
          settings.set_margin(left: 4)
          settings.num_cols = 2
          settings.full_border
          settings.set_padding(horiz: 1)
          settings.width = 9
          settings.align = :right
          settings.bold = true

          ['P x D    ', position.real * position.imag]
        end
      end

      composer.add_box do |_, settings|
        settings.set_padding(left: position.real, top: position.imag)

        SUBMARINE
      end
    end
  end
end


class Application
  COMMANDS = {
    'forward' => ->(v) { v },
    'down' => ->(v) { v * 1i },
    'up' => ->(v) { v * -1i }
  }

  def start(producer)
    lines = File.readlines(File.join(File.dirname(__FILE__), 'input.txt'))
    producer.add_frame('start', duration: 5)
    position = 0
    producer.frameset(12, easing: :bezier) do |fs|
      lines.each do |line|
        parts = line.split(' ')
        command = COMMANDS[parts.first]
        position += command.call(parts.last.to_i)
        fs.add_frame('submarine', args: { position: position, command: line })
      end
    end
    producer.add_frame('submarine', duration: 5, args: { position: position, command: '<EOF>' })
  end
end

WhirledPeas.configure do |config|
  config.application = Application.new
  config.template_factory = TemplateFactory.new
end