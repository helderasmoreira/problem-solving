require 'pry-byebug'

instruction = File.readlines('puzzle.input', chomp: true).join
matches = instruction.scan(/mul\((\d{1,3}),(\d{1,3})\)/i).to_a.flatten.map(&:to_i)

puts matches.each_slice(2).map { |a, b| a * b }.sum
