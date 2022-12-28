require 'pry-byebug'
require 'amazing_print'

valves = File.readlines('puzzle.input', chomp: true).map do |line|
  line.match(/Valve ([A-Z]{2}) has flow rate=(\d+); tunnels? leads? to valves? (.*)/).captures.then do |tokens|
    [tokens[0], [tokens[1].to_i, tokens[2].split(', ')]]
  end
end.to_h
# { 'AA' => [10, 'BB, CC'], 'BB' => .. }

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

queue = [
  [
    current = 'AA',                    # me current position
    elephant_current = 'AA',           # elephant current position
    opened = [],                       # valves opened
    elephant_opened = [],              # elephant valves opened
    pressure = 0,                      # total pressure
    remaining_time = 26,               # time remaining
    elephant_remaining_time = 26       # elephant time remaining
  ]
]

to_open = valves.select { |_, v| v[0] > 0 }.keys

max_pressure = 0
winner = nil

while queue.any?
  current, elephant_current, opened, elephant_opened, pressure, remaining_time, elephant_remaining_time = queue.shift

  (to_open - opened - elephant_opened).each do |first|
    # move me to first, elephant stay still
    me_to_first = DISTANCES["#{current}-#{first}"] || distance(valves, current, first)
    updated_time = remaining_time - me_to_first - 1

    unless updated_time <= 0
      updated_pressure = pressure + (valves[first][0] * updated_time)

      me_move = [
        first,
        elephant_current,
        (opened.clone << first),
        elephant_opened.clone,
        updated_pressure,
        updated_time,
        elephant_remaining_time
      ]

      if updated_pressure > max_pressure
        winner = me_move
        max_pressure = updated_pressure
      end
    end

    # move elephant to first, me stay still
    elephant_to_first = DISTANCES["#{elephant_current}-#{first}"] || distance(valves, elephant_current, first)
    updated_elephant_remaining_time = elephant_remaining_time - elephant_to_first - 1

    unless updated_elephant_remaining_time <= 0
      updated_pressure = pressure + (valves[first][0] * updated_elephant_remaining_time)

      elephant_move = [
        current,
        first,
        opened.clone,
        (elephant_opened.clone << first),
        updated_pressure,
        remaining_time,
        updated_elephant_remaining_time
      ]

      if updated_pressure > max_pressure
        winner = me_move
        max_pressure = updated_pressure
      end
    end

    if updated_time < updated_elephant_remaining_time
      queue.unshift(*[elephant_move, me_move].compact)
    else
      queue.unshift(*[me_move, elephant_move].compact)
    end
  end
end

puts winner.inspect
puts max_pressure
