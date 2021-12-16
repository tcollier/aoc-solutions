require_relative 'io_helpers'

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

def parse_value(msg)
  value = 0
  while msg.getc == 1
    value = (value + msg.gets(4)) << 4
  end
  value + msg.gets(4)
end

def eval_sub_msgs_by_bits(bits_to_read, msg)
  values = []
  sub_msgs = SubstringIO.new(msg, bits_to_read)
  while !sub_msgs.eof?
    values << eval_msg(sub_msgs)
  end
  values
end

def eval_sub_msgs_by_count(sub_packets, msg)
  sub_packets.times.map { eval_msg(msg) }
end

def eval_msg(msg)
  version = msg.gets(3)
  VERSIONS << version

  type_id = msg.gets(3)

  return parse_value(msg) if type_id == 4
  OPS[type_id][msg.getc == 0 ?
    eval_sub_msgs_by_bits(msg.gets(15), msg) :
    eval_sub_msgs_by_count(msg.gets(11), msg)
  ]
end

result = eval_msg(HexToBinIO.new($<))
puts VERSIONS.sum
puts result
