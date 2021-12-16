MESSAGE = $<.gets.chomp.chars.map { "%04d" % _1.to_i(16).to_s(2) }.join

def parse_value(message)
  value = ''
  index = 0
  while message[index] == '1'
    value += message[(index + 1)..(index + 4)]
    index += 5
  end
  value += message[(index + 1)..(index + 4)]
  [value.to_i(2), index + 5]
end

def parse_subpackets_by_bits(bits_to_read, message)
  values = []
  while bits_to_read > 0
    value, remainder = parse_message(message)
    values << value
    bits_to_read -= (message.length - remainder.length)
    message = remainder
  end
  [values, message]
end

def parse_subpackets_by_count(sub_packets, message)
  values = []
  sub_packets.times do
    value, remainder = parse_message(message)
    values << value
    message = remainder
  end
  [values, message]
end

VERSIONS = []

OPS = [
  -> { _1.inject(:+) },
  -> { _1.inject(:*) },
  -> { _1.min },
  -> { _1.max },
  nil,
  -> { _1[0] > _1[1] ? 1 : 0 },
  -> { _1[0] < _1[1] ? 1 : 0 },
  -> { _1[0] == _1[1] ? 1 : 0 },
]

def parse_message(message)
  version, type_id, message = message[0..2].to_i(2), message[3..5].to_i(2), message[6..-1]
  VERSIONS << version

  if type_id == 4
    value, bits_read = parse_value(message)
    [value, message[bits_read..-1]]
  else
    values, message = if message[0] == '0'
      parse_subpackets_by_bits(message[1..15].to_i(2), message[16..-1])
    else
      parse_subpackets_by_count(message[1..11].to_i(2), message[12..-1])
    end
    op = OPS[type_id]
    value = op[values]
    [value, message]
  end
end

result, _ = parse_message(MESSAGE)
puts VERSIONS.sum
puts result