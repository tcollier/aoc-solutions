require 'whirled_peas'

class TemplateFactory
  NUM_DIM_ROWS = 30
  DIM_ROW_BUFFER = 5
  SCROLL_ON_ROW = NUM_DIM_ROWS - DIM_ROW_BUFFER

  CURRENT_GIFT_COLOR = :yellow
  CURRENT_SIDE_COLOR = :magenta
  CURRENT_SLACK_COLOR = :cyan

  def build(frame, args)
    set_state(frame, args)

    WhirledPeas.template do |t|
      t.add_box('Body') do |body, settings|
        settings.flow = :t2b
        settings.auto_margin = true
        settings.set_margin(top: 2)

        body.add_box('Title', &method(:title))
        body.add_box('Content') do |content, settings|
          settings.flow = :l2r
          content.add_box('DimsList', &method(:dims_list))
          content.add_grid('Results', &method(:results))
        end
      end
    end
  end

  private

  def set_state(frame, args)
    @frame = frame
    @slack = frame == 'add-slack'
    @dims = args['dims'] if args.key?('dims')
    @index = args['index'] if args.key?('index')
    @solved = frame == 'finish'
    @sides = args['sides'] if args.key?('sides')
    @area = args['area'] if args.key?('area')
    @gift_area = args['gift_area'] if args.key?('gift_area')
    @total_area = args['total_area'] if args.key?('total_area')
  end

  def dims
    @dims || []
  end

  def index
    @index || -1
  end

  def sides
    @sides || []
  end

  def slack?
    @slack
  end

  def solved?
    @solved
  end

  def title(elem, settings)
    settings.auto_margin = true
    settings.underline = true
    settings.bold = true
    "Advent Of Code: 2015 Day 2 Part 1"
  end

  def dims_list(elem, settings)
    return '' if dims.length == 0
    settings.flow = :t2b
    settings.full_border
    scroll_height = (NUM_DIM_ROWS.to_f / dims.length).ceil

    if index <= SCROLL_ON_ROW
      visible_dims = dims[0..NUM_DIM_ROWS - 1]
      start_index = 0
      relative_index = index
    elsif index > dims.length - DIM_ROW_BUFFER - 1
      start_index = dims.length - NUM_DIM_ROWS
      visible_dims = dims[start_index..-1]
      relative_index = index - start_index
    else
      start_index = index - SCROLL_ON_ROW
      visible_dims = dims[start_index..index + DIM_ROW_BUFFER - 1]
      relative_index = SCROLL_ON_ROW
    end
    min_scroll = ((start_index.to_f / dims.length) * NUM_DIM_ROWS).floor
    max_scroll = min_scroll + scroll_height

    drew_scroll = false
    visible_dims.each.with_index do |dim, i|
      current_gift = !solved? && relative_index == i
      elem.add_box("Row-#{i}") do |row, settings|
        settings.clear_border
        settings.clear_margin
        settings.bg_color = CURRENT_GIFT_COLOR if current_gift
        settings.flow = :l2r
        row.add_text do |_, settings|
          current_gift ? '⇨ ' : '  '
        end
        row.add_text do |_, settings|
          settings.width = 2
          settings.align = :right
          if current_gift && sides.include?(0)
            settings.bold = true
            if slack?
              settings.color = CURRENT_SLACK_COLOR
            else
              settings.color = CURRENT_SIDE_COLOR
            end
          end
          dim[0].to_s
        end
        row.add_text { ' x ' }
        row.add_text do |_, settings|
          settings.width = 2
          settings.align = :right
          if current_gift && sides.include?(1)
            settings.bold = true
            if slack?
              settings.color = CURRENT_SLACK_COLOR
            else
              settings.color = CURRENT_SIDE_COLOR
            end
          end
          dim[1].to_s
        end
        row.add_text { ' x ' }
        row.add_text do |_, settings|
          settings.width = 2
          settings.align = :right
          if current_gift && sides.include?(2)
            settings.bold = true
            if slack?
              settings.color = CURRENT_SLACK_COLOR
            else
              settings.color = CURRENT_SIDE_COLOR
            end
          end
          dim[2].to_s
        end
        row.add_text { (min_scroll...max_scroll).include?(i) ? ' ▐' : '  ' }
      end
    end
  end

  def results(elem, settings)
    settings.set_margin(left: 10)
    settings.num_cols = 2
    settings.set_padding(left: 3, right: 3)
    settings.full_border(style: :double)
    elem.add_text { 'STATUS' }
    elem.add_text do |_, settings|
      settings.align = :right
      settings.width = 20
      @frame
    end
    elem.add_text { slack? ? 'SLACK:' : 'CURRENT SIDE:' }
    elem.add_text do |_, settings|
      if solved?
        ''
      else
        settings.align = :right
        settings.width = 20
        settings.bg_color = slack? ? CURRENT_SLACK_COLOR : CURRENT_SIDE_COLOR
        "#{@area || 0} sqft"
      end
    end
    elem.add_text { "GIFT (%4d of %4d):" % [index + 1, dims.length] }
    elem.add_text do |_, settings|
      if solved?
        ''
      else
        settings.align = :right
        settings.width = 20
        settings.bg_color = CURRENT_GIFT_COLOR
        "#{@gift_area || 0} sqft"
      end
    end
    elem.add_text { "TOTAL AREA:" }
    elem.add_text do |_, settings|
      settings.align = :right
      settings.width = 20
      settings.bg_color = @solved ? :green : nil
      "#{@total_area || 0} sqft"
    end
  end
end

class Driver
  def start(producer)
    total_area = 0
    input = File.readlines(File.join(File.dirname(__FILE__), 'input.txt'))
    dims = input.map { |l| l.split('x').map(&:to_i) }
    producer.send('start', duration: 3, args: { dims: dims })
    dims = dims.map { |dim| dim.sort }
    producer.send('sort', duration: 3, args: { dims: dims })
    dims.each.with_index do |dim, index|
      duration = index < 7 || index > dims.length - 8 ? 0.25 : 0.0333
      producer.send('next-dim', args: { index: index })
      gift_area = 2 * dim[0] * dim[1]
      producer.send('add-side', duration: duration, args: { sides: [0, 1], area: gift_area, gift_area: gift_area })
      area = 2 * dim[0] * dim[2]
      gift_area += area
      producer.send('add-side', duration: duration, args: { sides: [0, 2], area: area, gift_area: gift_area })
      area = 2 * dim[1] * dim[2]
      gift_area += area
      producer.send('add-side', duration: duration, args: { sides: [1, 2], area: area, gift_area: gift_area })
      area = dim[0] * dim[1]
      gift_area += area
      producer.send('add-slack', duration: duration, args: { sides: [0, 1], area: area, gift_area: gift_area })
      total_area += gift_area
      producer.send('update-total', args: { total_area: total_area })
    end
    producer.send('finish', args: { total_area: total_area })
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
  puts TemplateFactory.new.build('foo', 'dims' => (1..10).map { |i| [i, i, i]}).inspect
else
  WhirledPeas.start(Driver.new, TemplateFactory.new)
end
