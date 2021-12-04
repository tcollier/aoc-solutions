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

        # Transpose card to get easy access to the columns
        transposed = [[numbers[j][i] for j in range(len(numbers))] for i in range(len(numbers[0]))]
        for column in transposed:
            winners.append(set(column))

        return winners


class Game(object):
    def __init__(self, cards):
        self._cards = cards
        self.winning_called = []
        self.losing_called = []

    def play(self, ordered):
        winning_card = None
        losing_card = None
        cards = self._cards
        for current in ordered:
            if not winning_card:
                self.winning_called.append(current)
            if not losing_card:
                self.losing_called.append(current)
            if len(self.losing_called) >= 5:
                called_set = set(self.losing_called)
                next_cards = []
                for card in cards:
                    if card.is_winner(called_set):
                        if not winning_card:
                            winning_card = card
                        if len(cards) == 1:
                            losing_card = cards[0]
                    else:
                        next_cards.append(card)
                cards = next_cards
        return (winning_card, losing_card)


ordered = [n for n in lines[0][0].split(",")]
cards = []
for i in range((len(lines) - 1) // 6):
    cards.append(Card(lines[(2 + 6 * i):(1 + 6 * (i + 1))]))


game = Game(cards)
winning_card, losing_card = game.play(ordered)
print(winning_card.score(game.winning_called) * int(game.winning_called[-1]))
print(losing_card.score(game.losing_called) * int(game.losing_called[-1]))

