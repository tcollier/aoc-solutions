class HexToBinIO
  def initialize(io)
    @io = io
    @buff = ''
  end

  def getc
    gets(1)
  end

  def gets(num_chars)
    str = ''
    if @buff.length > 0
      next_index = [num_chars, @buff.length].min
      str += @buff[0..(next_index - 1)]
      @buff = @buff[next_index..-1]
      num_chars -= next_index
    end
    read_chars = num_chars / 4
    str += conv(@io.gets(read_chars)) if read_chars > 0
    num_chars -= read_chars * 4
    if num_chars > 0
      bin = conv(@io.getc)
      str += bin[0..(num_chars - 1)]
      @buff = bin[num_chars..-1]
    end
    str.to_i(2)
  end

  private

  def conv(hexstr)
    raise ArgumentError.new("Invalid hex string: #{hexstr.inspect}") unless hexstr =~ /[0-9a-f]+/i
    hexstr.chars.map { "%04d" % _1.to_i(16).to_s(2) }.join
  end
end

class SubstringIO
  def initialize(io, len)
    @io = io
    @len = len
  end

  def eof?
    @len == 0
  end

  def getc
    gets(1)
  end

  def gets(num_chars)
    num_chars = [num_chars, @len].min
    @len -= num_chars
    @io.gets(num_chars)
  end
end
