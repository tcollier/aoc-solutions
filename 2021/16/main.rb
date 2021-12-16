MESSAGE = $<.gets.chomp.chars.map { "%04d" % _1.to_i(16).to_s(2) }.join

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

def parse_value(message)
  value = ''
  index = 0
  while message[index] == '1'
    value += message[(index + 1)..(index + 4)]
    index += 5
  end
  value += message[(index + 1)..(index + 4)]
  [value.to_i(2), message[(index + 5)..-1]]
end

def parse_subpackets_by_bits(bits_to_read, message, type_id)
  values = []
  while bits_to_read > 0
    value, remainder = parse_message(message)
    values << value
    bits_to_read -= (message.length - remainder.length)
    message = remainder
  end
  [OPS[type_id][values], message]
end

def parse_subpackets_by_count(sub_packets, message, type_id)
  values = sub_packets.times.map do
    (value, message = parse_message(message)).first
  end
  [OPS[type_id][values], message]
end

def parse_message(message)
  version, type_id, message = message[0..2].to_i(2), message[3..5].to_i(2), message[6..-1]
  VERSIONS << version

  return parse_value(message) if type_id == 4
  if message[0] == '0'
    parse_subpackets_by_bits(message[1..15].to_i(2), message[16..-1], type_id)
  else
    parse_subpackets_by_count(message[1..11].to_i(2), message[12..-1], type_id)
  end
end

result, _ = parse_message(MESSAGE)
puts VERSIONS.sum
puts result