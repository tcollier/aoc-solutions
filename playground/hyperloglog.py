from functools import reduce
from math import floor
from random import choice
from string import ascii_lowercase

def generate_words(num_words):
    for _ in range(num_words):
        yield "".join(choice(ascii_lowercase) for i in range(4))


def count_trailing_zeros(num):
    num_zeros = 0
    while num & 1 == 0:
        num_zeros += 1
        num >>= 1
    return num_zeros


class SetCounter(object):
    def __init__(self):
        self.words = set()
        
    def count(self, word):
        self.words.add(word)
    
    def card(self):
        return len(self.words)


class LogLogCounter(object):
    def __init__(self):
        self.max_num_zeros = 0

    def count_hash(self, hash_value):
        num_zeros = count_trailing_zeros(hash_value)
        if num_zeros > self.max_num_zeros:
            self.max_num_zeros = num_zeros
        
    def count(self, word):
        self.count_hash(hash(word))
    
    def card(self):
        return 2 ** self.max_num_zeros


class HyperLogLogCounter(object):
    """
    See https://github.com/svpcom/hyperloglog for better implementation
    """
    def __init__(self, counter_bits):
        self.counter_bits = counter_bits
        self.mask = 1
        for _ in range(counter_bits - 1):
            self.mask <<= 1
            self.mask += 1
        self.counters = []
        for _ in range(2 ** counter_bits):
            self.counters.append(LogLogCounter())

    def count(self, word):
        hash_value = hash(word)
        counter_index = hash_value & self.mask
        hash_value >>= self.counter_bits
        self.counters[counter_index].count_hash(hash_value >> self.counter_bits)
        
    def card(self):
        max_zeros = [c.max_num_zeros for c in self.counters]
        reciprocals = [1 / n for n in max_zeros]
        harmonic_denominator = reduce(lambda a, b: a + b, reciprocals)
        harmonic_mean = len(self.counters) / harmonic_denominator
        return floor(len(self.counters) * 2 ** harmonic_mean)


def count_words(num_words, counter_bits):
    actual = 0
    counters = {
        'set': SetCounter(),
        'loglog': LogLogCounter(),
        'hyperloglog': HyperLogLogCounter(counter_bits)
    }
    print(f"Generating {num_words} random strings")
    for word in generate_words(num_words):
        for counter in counters.values():
            counter.count(word)
    return counters


def main(num_words, counter_bits):
    counters = count_words(num_words, counter_bits)
    for label, counter in counters.items():
        print(f"{label} cardinality: {counter.card()}")
    

if __name__ == "__main__":
    main(1000000, 7)