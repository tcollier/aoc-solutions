lines = [l.rstrip() for l in open("./input.txt", "r").readlines()]

def get_gamma(lines):
    bits = [0] * 12
    for line in lines:
        for index, digit in enumerate(line):
            bits[index] += 1 if digit == "1" else -1
    gamma = ""
    for bit in bits:
        gamma += "1" if bit >= 0 else "0"
    return gamma

def get_epsilon(lines):
    bits = [0] * 12
    for line in lines:
        for index, digit in enumerate(line):
            bits[index] += 1 if digit == "1" else -1
    epsilon = ""
    for bit in bits:
        epsilon += "0" if bit >= 0 else "1"
    return epsilon

print(int(get_gamma(lines), 2), int(get_epsilon(lines), 2))

o2_gen_candidates = set([l for l in lines])
co2_scrub_candidates = set([l for l in lines])

for index in range(len(lines[0])):
    gamma = get_gamma(o2_gen_candidates)
    if len(o2_gen_candidates) == 1:
        break
    next_candidates = set()
    for candidate in o2_gen_candidates:
        if candidate[index] == gamma[index]:
            next_candidates.add(candidate)
    o2_gen_candidates = next_candidates

print(get_epsilon(lines))
for index in range(len(lines[0])):
    epsilon = get_epsilon(co2_scrub_candidates)
    print(epsilon)
    if len(co2_scrub_candidates) == 1:
        break
    next_candidates = set()
    # print(len(co2_scrub_candidates))
    for candidate in co2_scrub_candidates:
        if candidate[index] == epsilon[index]:
            next_candidates.add(candidate)
    co2_scrub_candidates = next_candidates

print(int(o2_gen_candidates.pop(), 2) * int(co2_scrub_candidates.pop(), 2))
