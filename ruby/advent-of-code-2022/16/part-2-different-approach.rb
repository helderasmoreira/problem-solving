require 'pry-byebug'
require 'amazing_print'

valves = File.readlines('puzzle.input', chomp: true).map do |line|
  line.match(/Valve ([A-Z]{2}) has flow rate=(\d+); tunnels? leads? to valves? (.*)/).captures.then do |tokens|
    [tokens[0], [tokens[1].to_i, tokens[2].split(', ')]]
  end
end.to_h
# {'AA' => [10, 'BB, CC'], 'BB' => .. }

DISTANCES = {}
def distance(valves, from, to)
  queue = [from]
  distance = 0

  while !queue.empty?
    for i in 0..queue.length - 1
      name = queue.shift

      if name == to
        DISTANCES["#{from}-#{to}"] = distance
        return distance
      end

      valves[name][1].each { |name| queue.push(name) }
    end
    distance += 1
  end
end

MAX_PRESSURES = {}
def max_pressure_for(valves, to_open)
  queue = [
    [
      current = 'AA',           # current position
      opened = [],              # valves opened
      pressure = 0,             # total pressure
      remaining_time = 26       # time remaining
    ]
  ]

  max_pressure = 0

  while queue.any?
    current, opened, pressure, remaining_time = queue.shift

    (to_open - opened).each do |next_valve|
      distance_to_valve = DISTANCES["#{current}-#{next_valve}"] || distance(valves, current, next_valve)

      updated_time = remaining_time - distance_to_valve - 1
      next if updated_time <= 0

      updated_pressure = pressure + (valves[next_valve][0] * updated_time)

      to_explore = [
        next_valve,
        (opened.clone << next_valve),
        updated_pressure,
        updated_time
      ]

      queue << to_explore
      max_pressure = updated_pressure if updated_pressure > max_pressure
    end
  end

  MAX_PRESSURES[to_open.join('')] = max_pressure
  max_pressure
end

to_open = valves.select { |_, v| v[0] > 0 }.keys

combinations = []
for i in 0..(to_open.length) do
  combinations = combinations + to_open.combination(i).to_a
end

options = combinations.map do |combination|
  me = MAX_PRESSURES[combination.join('')] || max_pressure_for(valves, combination)

  elephant_to_move = to_open - combination
  elephant = MAX_PRESSURES[elephant_to_move.join('')] || max_pressure_for(valves, elephant_to_move)

  me + elephant
end

ap options.max
