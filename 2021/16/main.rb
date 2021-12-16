require 'stringio'

MESSAGE = StringIO.new($<.gets.chomp.chars.map { "%04d" % _1.to_i(16).to_s(2) }.join)

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
  value = ''
  value += msg.gets(4) while msg.getc == '1'
  (value + msg.gets(4)).to_i(2)
end

def eval_sub_msgs_by_bits(bits_to_read, msg)
  values = []
  sub_msgs = StringIO.new(msg.gets(bits_to_read))
  while !sub_msgs.eof?
    values << eval_msg(sub_msgs)
  end
  values
end

def eval_sub_msgs_by_count(sub_packets, msg)
  sub_packets.times.map { eval_msg(msg) }
end

def eval_msg(msg)
  version = msg.gets(3).to_i(2)
  VERSIONS << version

  type_id = msg.gets(3).to_i(2)

  return parse_value(msg) if type_id == 4
  OPS[type_id][msg.getc == '0' ?
    eval_sub_msgs_by_bits(msg.gets(15).to_i(2), msg) :
    eval_sub_msgs_by_count(msg.gets(11).to_i(2), msg)
  ]
end

result = eval_msg(MESSAGE)
puts VERSIONS.sum
puts result