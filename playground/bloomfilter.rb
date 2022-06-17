#!/usr/bin/env ruby

require 'benchmark'
require 'set'

DICTIONARY_FILE = "/usr/share/dict/words"
WORD_LENGTH = 3
VOWELS = %w[a e i o u]
CONSONANTS = (?a..?z).to_a - VOWELS
NUM_WORDS = 10000
NUM_BITS = 2 ** 14

class Bloomfilter
  def initialize(num_bits)
    @bits = Array.new(num_bits) { false }
  end

  def add(word)
    bits[word.hash % bits.length] = true
  end

  def maybe_contains?(word)
    bits[word.hash % bits.length]
  end

  def hit_rate
    bits.count { _1 }.to_f / bits.count
  end

  private

  attr_reader :bits
end

class WordStore
  def initialize(bloomfilter)
    @words = Set.new
    @bloomfilter = bloomfilter
  end

  def add(word)
    bloomfilter.add(word)
    words << word.downcase
  end

  def raw_contains?(word)
    words.include?(word.downcase)
  end

  def optimized_contains?(word)
    return false unless bloomfilter.maybe_contains?(word)
    slow_contains?(word)
  end

  def slow_contains?(word)
    sleep(0.000005)
    raw_contains?(word)
  end

  private

  attr_reader :words, :num_bits, :bloomfilter
end

def build_word_store(file, word_length, bloomfilter)
  word_store = WordStore.new(bloomfilter)
  for line in open(file, "r").readlines()
    word = line.rstrip
    word_store.add(word) if word.length == word_length
  end
  return word_store
end

def random_word(word_length)
  letters = (word_length / 2).times.map { VOWELS.sample }
  letters += (word_length - letters.length).times.map { CONSONANTS.sample }
  letters.shuffle.join
end

def random_words(num_words, word_length, &block)
  num_words.times do
    yield random_word(word_length)
  end
end

BLOOMFILTER = Bloomfilter.new(NUM_BITS)
WORD_STORE = build_word_store(DICTIONARY_FILE, WORD_LENGTH, BLOOMFILTER)
hit_rate = '%0.2f' % (BLOOMFILTER.hit_rate * 100)

puts "#{hit_rate}% of bloomfilter bits are set"
puts

def hit_rate(word_store, contains_method, num_words, word_length)
  hits = 0
  random_words(num_words, word_length) do |word|
    hits += 1 if word_store.send(contains_method, word)
  end
  hits.to_f / num_words
end

hit_rates = {}
Benchmark.bm do |bm|
  bm.report('baseline ') { hit_rates[:baseline] = hit_rate(WORD_STORE, :raw_contains?, NUM_WORDS, WORD_LENGTH) }
  bm.report('optimized') { hit_rates[:optimized] = hit_rate(WORD_STORE, :optimized_contains?, NUM_WORDS, WORD_LENGTH) }
  bm.report('slow     ') { hit_rates[:slow] = hit_rate(WORD_STORE, :slow_contains?, NUM_WORDS, WORD_LENGTH) }
end
puts
hit_rates.each do |label, hit_rate|
  puts "#{label}: hit rate: %0.2f" % (hit_rate * 100) + '%'
end
