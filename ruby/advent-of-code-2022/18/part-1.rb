require 'pry-byebug'

Cube = Struct.new(:x, :y, :z)

cubes = File.readlines('puzzle.input', chomp: true).map do |line|
  Cube.new(*line.split(',').map(&:to_i))
end

def manhattan_distance(a, b)
  (a.x - b.x).abs + (a.y - b.y).abs + (a.z - b.z).abs
end

def adjacent?(a, b)
  manhattan_distance(a, b) == 1
end

faces_exposed = cubes.map do |cube|
  6 - cubes.count { |other_cube| adjacent?(cube, other_cube) }
end

puts faces_exposed.sum
