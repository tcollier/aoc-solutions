require 'set'

CHARS = <<-EOS
 ##  ###   ##  ###  #### ####  ##  #  # ###    ## #  # #    #  # #  #  ##  ###   ##  ###   ##  ###  #  # #  # #  # #  # #  # ####
#  # #  # #  # #  # #    #    #  # #  #  #      # # #  #    # ## ## # #  # #  # #  # #  # #  #  #   #  # #  # #  # #  # #  #    #
#  # ###  #    #  # ###  ###  #    ####  #      # ##   #    #### ## # #  # #  # #  # #  #  #    #   #  # #  # #  #  ##   ##    #
#### #  # #    #  # #    #    # ## #  #  #      # # #  #    #  # # ## #  # ###  #  # ###    #   #   #  # #  # #### #  #   #   #
#  # #  # #  # #  # #    #    #  # #  #  #   #  # # #  #    #  # # ## #  # #    # ## # #  #  #  #   #  #  ##  # ## #  #   #  #
#  # ###   ##  ###  #### #     ### #  # ###   ##  #  # #### #  # #  #  ##  #     ### #  #  ##   #    ##   ##  #  # #  #   #  ####
EOS

class Ocr
  CHAR_DOTS = (?A..?Z).map.with_index do |char, index|
    char_dots = Set.new
    char_start_col = (char.ord - ?A.ord) * 5
    CHARS.split("\n").each.with_index do |row, row_index|
      (char_start_col..(char_start_col + 4)).each do |col_index|
        char_dots.add(col_index - char_start_col + row_index * 1i) if row[col_index] == ?#
      end
    end
    char_dots
  end

  def initialize(dots)
    @dots = dots
  end

  def to_s
    str = ''
    start_x = 0
    max_x = dots.map(&:real).max
    while start_x < max_x
      char_dots = Set.new(dots.select { (start_x..(start_x + 4)).include?(_1.real) }.map { _1 - start_x })
      index = CHAR_DOTS.index(char_dots)
      str += index.nil? ? ?? : (?A.ord + index).chr
      start_x += 5
    end
    str
  end

  private

  attr_reader :dots
end