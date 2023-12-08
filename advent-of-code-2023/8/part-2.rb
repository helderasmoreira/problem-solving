require 'pry-byebug'

lines = File.readlines('puzzle.input', chomp: true)

instructions = lines.first.split('')
nodes = lines[2..].map do |line|
  x, l, r = line.scan(/(\w{3}) = \((\w{3}), (\w{3})\)/).first
  [x, { 'L' => l, 'R' => r }]
end.to_h

currents = nodes.keys.select { |node| node.end_with? 'A' }
currents.map! do |node|
  n = 0
  instructions.cycle.each do |instruction|
    break n if node.end_with? 'Z'

    node = nodes[node][instruction]
    n +=1
  end
end

puts currents.reduce(1, :lcm)
