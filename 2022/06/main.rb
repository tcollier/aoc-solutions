#!/usr/bin/env ruby

class MarkerDetector
  attr_reader :found_position

  def initialize(length)
    @chars = Array.new(length)
    @index = 0
    @counts = {}
    @found_position = nil
  end

  def feed(char)
    prev_char = chars[index % chars.length]
    chars[index % chars.length] = char
    @index += 1
    if prev_char != char
      counts[char] ||= 0
      counts[char] += 1
      if !prev_char.nil?
        if counts[prev_char] == 1
          counts.delete(prev_char)
        else
          @counts[prev_char] -= 1
        end
      end
    end
    @found_position = index if found_position.nil? && counts.length == chars.length
  end

  private

  attr_reader :counts, :chars, :index
end

start_of_packet_marker_detector = MarkerDetector.new(4)
start_of_message_marker_detector = MarkerDetector.new(14)

input = $<.first
input.length.times do |index|
  start_of_packet_marker_detector.feed(input[index])
  start_of_message_marker_detector.feed(input[index])
  break if !start_of_packet_marker_detector.found_position.nil? && !start_of_message_marker_detector.found_position.nil?
end

puts start_of_packet_marker_detector.found_position
puts start_of_message_marker_detector.found_position
