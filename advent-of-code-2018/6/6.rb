require 'set'

input = File.readlines('6.input', chomp: true)

Coordinate = Struct.new(:x, :y)
COORDINATES = input.map { |xy| Coordinate.new(*xy.scan(/(\d+)/).flatten.map(&:to_i)) }

max_x = COORDINATES.map { |c| c.x }.sort.last
max_y = COORDINATES.map { |c| c.y }.sort.last

def manhattan(c1, c2)
  (c1.x - c2.x).abs + (c1.y - c2.y).abs
end

def all_manhattans(coord)
  COORDINATES.map { |c| [c, manhattan(c, coord)] }.sort_by { |c| c.last }
end

area = Hash.new(0)
combined_manhattans = Hash.new(0)
infinite = Set.new

0.upto(max_y) do |y|
  0.upto(max_x).map do |x|
    coord = Coordinate.new(x, y)

    result = all_manhattans(coord)

    best = result[0][1] == result[1][1] ? nil : result[0][0]
    area[best] += 1 unless best.nil?

    combined_manhattans[coord] = result.map(&:last).reduce(:+)

    infinite << best if x == 0 || y == 0 || x == (max_x) || y == (max_y)
  end
end

p area.select { |k, _ | !infinite.include? k }.max_by { |_, v| v }
p combined_manhattans.select { |_, v| v < 10_000 }.size
