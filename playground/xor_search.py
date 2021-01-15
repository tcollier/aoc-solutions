import random

NUM_BITS = 7

missing = random.randint(0, (1 << NUM_BITS) - 1)
data = {i for i in range(1 << NUM_BITS) if i != missing}

search = 0
for val in data:
    search ^= val

print(missing, search)
