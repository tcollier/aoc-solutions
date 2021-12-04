lines = [[n for n in l.rstrip().split()] for l in open("./input.txt", "r").readlines()]

class Card(object):
    def __init__(self, numbers):
        self._numbers = numbers
        self._winners = self.get_winners(numbers)

    def is_winner(self, called):
        for winner in self._winners:
            if not winner - called:
                return True
        return False

    def score(self, called):
        total = 0
        for row in self._numbers:
            for number in row:
                if number not in called:
                    total += int(number)
        return total

    @staticmethod
    def get_winners(numbers):
        winners = []
        # Add all rows of the card as winners
        for row in numbers:
            winners.append(set(row))

        # Add diagonals as winners
        winners.append(set([
            numbers[0][0],
            numbers[1][1],
            numbers[2][2],
            numbers[3][3],
            numbers[4][4],
        ]))
        winners.append(set([
            numbers[0][4],
            numbers[1][3],
            numbers[2][2],
            numbers[3][1],
            numbers[4][0],
        ]))

        # Transpose card to get easy access to the columns
        transposed = [[numbers[j][i] for j in range(len(numbers))] for i in range(len(numbers[0]))]
        for column in transposed:
            winners.append(set(column))

        return winners


class Game(object):
    def __init__(self, cards):
        self._cards = cards
        self.called = []

    def play(self, ordered):
        for current in ordered:
            self.last_called = current
            self.called.append(current)
            if len(self.called) >= 5:
                called_set = set(self.called)
                for card in self._cards:
                    if card.is_winner(called_set):
                        return card
        raise NotImeplemetedError()



ordered = [n for n in lines[0][0].split(",")]
cards = []
for i in range((len(lines) - 1) // 6):
    cards.append(Card(lines[(2 + 6 * i):(1 + 6 * (i + 1))]))


game = Game(cards)
winning_card = game.play(ordered)
print(winning_card.score(game.called) * int(game.called[-1]))

