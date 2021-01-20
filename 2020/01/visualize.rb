require 'whirled_peas'

class TemplateFactory
  def initialize
    @numbers = []
  end

  def title(elem, settings)
    settings.auto_margin = true
    settings.underline = true
    settings.bold = true
    "Advent Of Code: Day 1 Part 2"
  end

  def results(elem, settings)
    settings.auto_margin = true
    settings.num_cols = 4
    settings.set_padding(top: 1, bottom: 1, left: 3, right: 3)
    settings.full_border(style: :double)
    elem.add_text { "SUM:" }
    elem.add_text do |_, settings|
      settings.align = :right
      settings.width = 9
      settings.bg_color = @solved ? :green : :magenta
      @sum.nil? ? 'N/A' : @sum.to_s
    end
    elem.add_text { "PRODUCT:" }
    elem.add_text do |_, settings|
      settings.align = :right
      settings.width = 10
      settings.bg_color = @solved ? :green : :magenta
      @product.nil? ? 'N/A' : @product.to_s
    end
  end

  def number_grid(elem, settings)
    settings.auto_margin = true
    settings.num_cols = 20
    settings.set_padding(top: 0, left: 1, right: 1)
    settings.full_border(style: :soft)
    @numbers.each.with_index do |num, index|
      elem.add_text do |_, ts|
        ts.align = :right
        ts.width = 4
        if @i == index
          ts.bg_color = :cyan
        elsif @j == index
          ts.bg_color = :red
        elsif @k == index
          ts.bg_color = :magenta
        end
        num.to_s
      end
    end
end

  def build(name, args)
    @numbers = args['numbers'] if args.key?('numbers')
    @solved = name == 'success'
    @sum = args['i'] && (@numbers[args['i']] + @numbers[args['j']] + @numbers[args['k']])
    @product = args['i'] && (@numbers[args['i']] * @numbers[args['j']] * @numbers[args['k']])
    @i = args['i']
    @j = args['j']
    @k = args['k']
    WhirledPeas.template do |t|
      t.add_box do |body, os|
        os.set_margin(top: 2)
        os.display_flow = :block
        os.auto_margin = true
        body.add_box(&method(:title))
        body.add_grid(&method(:results))
        body.add_grid(&method(:number_grid))
      end
    end
  end
end

class Driver
  TARGET = 2020
  def start(producer)
    numbers = File.readlines(File.join(File.dirname(__FILE__), 'input.txt')).map(&:to_i)
    producer.send('load', frames: 50, args: { numbers: numbers })
    numbers.sort!
    producer.send('sort', frames: 50, args: { numbers: numbers })
    (numbers.length - 2).times do |i|
      j = i + 1
      k = numbers.length - 1
      while j < k
        sum = numbers[i] + numbers[j] + numbers[k]
        producer.send('attempt', args: { i: i, j: j, k: k })
        if sum == 2020
          producer.send('success', frames: 100, args: { i: i, j: j, k: k })
          return
        elsif sum > TARGET
          k -= 1
        else
          j += 1
        end
      end
    end
  rescue
    producer.send('failure')
    raise
  end
end

class TermApp
  def start(producer)
  end
end

if ARGV.last == '--debug'
  puts TemplateFactory.new.build('foo', 'numbers' => 10.times.map(&:itself)).inspect
else
  WhirledPeas.start(Driver.new, TemplateFactory.new)
end
