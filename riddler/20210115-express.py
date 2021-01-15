import math
import random

NUM_ITERATIONS = 1000000
MIN_MAX = (474, 525)
outcomes = {}
for val in range(*MIN_MAX):
    guess = val / 10
    outcomes[guess] = 0
    for _ in range(NUM_ITERATIONS):
        if guess < random.random() * 100:
            outcomes[guess] += guess / NUM_ITERATIONS

for guess in outcomes.keys():
    print(
        str(guess).rjust(2),
        round(outcomes[guess], 2),
        "#" * math.floor(outcomes[guess]),
    )
