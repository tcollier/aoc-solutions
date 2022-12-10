#!/usr/bin/env python

TEAMS = ["A", "B", "C", "D"]
GAMES = [(a, b) for i, a in enumerate(TEAMS) for b in TEAMS[i + 1:]]
OUTCOMES = [(3, 0), (1, 1), (0, 3)]
RESULTS = set()
for universe in range(pow(len(OUTCOMES), len(GAMES))):
    results = {t: 0 for t in TEAMS}
    for game in GAMES:
        outcome = OUTCOMES[universe % len(OUTCOMES)]
        universe //= len(OUTCOMES)
        results[game[0]] += outcome[0]
        results[game[1]] += outcome[1]
    RESULTS.add(tuple(sorted([v for _, v in results.items()])))
print(len(RESULTS))