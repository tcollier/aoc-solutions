lines = [l.rstrip() for l in open("./input.txt", "r").readlines()]


PART_1_COMMANDS = {
    "forward": lambda val: val,
    "down": lambda val: val * 1j,
    "up": lambda val: val * -1j,
}
part_1_position = 0
for line in lines:
    parts = line.split(" ")
    part_1_position += PART_1_COMMANDS[parts[0]](int(parts[1]))
print(int(part_1_position.real) * int(part_1_position.imag))


PART_2_COMMANDS = {
    "forward": lambda pos, aim, val: (pos + val + (aim * val * 1j), aim),
    "down": lambda pos, aim, val: (pos, aim + val),
    "up": lambda pos, aim, val: (pos, aim - val),
}
part_2_position = 0
aim = 0
for line in lines:
    parts = line.split(" ")
    part_2_position, aim = PART_2_COMMANDS[parts[0]](part_2_position, aim, int(parts[1]))
print(int(part_2_position.real) * int(part_2_position.imag))
