require 'set'

def manhattan(one, another)
  (one[0] - another[0]).abs + (one[1] - another[1]).abs
end

def range_for_sensor_at_y(sensor, distance, y)
  delta_y = (sensor[1] - y).abs
  return if delta_y > distance

  delta_x = (distance - delta_y).abs

  (sensor[0] - delta_x)..(sensor[0] + delta_x)
end

def overlap?(one, other)
  one.cover?(other.first) || other.cover?(one.first)
end

input = File.readlines('puzzle.input', chomp: true).map do |line|
  line.match(/.*x=(-?\d*).*y=(-?\d*).*x=(-?\d*).*y=(-?\d*)/).captures.map(&:to_i).then do |tokens|
    [[tokens[0], tokens[1]], [tokens[2], tokens[3]]]
  end
end.to_h

0.upto(4_000_000) do |y|
  ranges = []
  beacons_in_y = Set.new

  input.each do |sensor, beacon|
    beacons_in_y.add(beacon) if beacon[1] == y

    distance = manhattan(sensor, beacon)
    range_for_sensor = range_for_sensor_at_y(sensor, distance, y)
    next if range_for_sensor.nil?

    if ranges.empty?
      ranges << (range_for_sensor)
    elsif ranges.any? { |range| range.cover?(range_for_sensor) }
      next
    else
      matching_ranges = ranges.select { |range| overlap?(range, range_for_sensor) }

      if matching_ranges.empty?
        ranges << range_for_sensor
      else
        matching_ranges.each { |matching_range| ranges.delete(matching_range) }
        ranges << (matching_ranges.map(&:begin).push(range_for_sensor.begin).min..matching_ranges.map(&:end).push(range_for_sensor.end).max)
      end
    end
  end

  if ranges.size > 1
    puts (ranges.map(&:end).min + 1) * 4_000_000 + y
    break
  end
end
