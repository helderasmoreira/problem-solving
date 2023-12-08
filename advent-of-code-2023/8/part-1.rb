require 'pry-byebug'

GOAL = 'ZZZ'.freeze

lines = File.readlines('puzzle.input', chomp: true)

instructions = lines.first.split('')
nodes = lines[2..].map do |line|
  x, l, r = line.scan(/(\w{3}) = \((\w{3}), (\w{3})\)/).first
  [x, { 'L' => l, 'R' => r }]
end.to_h

n = 0
current = 'AAA'
instructions.cycle.each do |instruction|
  break if current == GOAL

  current = nodes[current][instruction]
  n +=1
end

puts n
