require 'pry-byebug'

MAX = {
  'red' => 12,
  'green' => 13,
  'blue' => 14,
}.freeze

def set_possible?(set)
  set.split(', ').all? do |cube|
    n, colour = cube.split(' ')
    n.to_i <= MAX[colour]
  end
end

total = 0

File.readlines('puzzle.input', chomp: true).each_with_index do |game, index|
  sets = game.scan(/(?:Game \d+: )?((?:\d+\s\w+,\s*)*\d+\s\w+)/).flatten
  total += (index + 1) if sets.all? { |set| set_possible?(set) }
end

puts total
