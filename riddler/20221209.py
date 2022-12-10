#!/usr/bin/env python

from random import random

def play_game(team_1, team_2):
    return team_1 if random() < team_1[1] / pow(team_1[1] + team_2[1], 2) else team_2

def play_round():
    teams = sorted([(i, random()) for i in range(4)])
    winner_1 = play_game(teams[0], teams[3])
    winner_2 = play_game(teams[2], teams[1])
    winner_3 = play_game(winner_1, winner_2)
    return winner_3[1]

iters = 1000000
total = 0
for _ in range(iters):
    total += play_round()

print(total / iters)
