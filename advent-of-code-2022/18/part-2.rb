require 'pry-byebug'

Cube = Struct.new(:x, :y, :z)

cubes = File.readlines('puzzle.input', chomp: true).map do |line|
  Cube.new(*line.split(',').map(&:to_i))
end

def adjacent_cubes_for(cube)
  [
    Cube.new(cube.x, cube.y, cube.z + 1),
    Cube.new(cube.x, cube.y, cube.z - 1),
    Cube.new(cube.x, cube.y + 1, cube.z),
    Cube.new(cube.x, cube.y - 1, cube.z),
    Cube.new(cube.x + 1, cube.y, cube.z),
    Cube.new(cube.x - 1, cube.y, cube.z)
  ]
end

def manhattan_distance(a, b)
  (a.x - b.x).abs + (a.y - b.y).abs + (a.z - b.z).abs
end

def adjacent?(a, b)
  manhattan_distance(a, b) == 1
end

min_x, max_x = cubes.map(&:x).minmax.then { |min, max| [min - 1, max + 1] }
min_y, max_y = cubes.map(&:y).minmax.then { |min, max| [min - 1, max + 1] }
min_z, max_z = cubes.map(&:z).minmax.then { |min, max| [min - 1, max + 1] }

queue = []
negative_space = []
all_space = []

(min_x..max_x).to_a.each do |x|
  (min_y..max_y).to_a.each do |y|
    queue << Cube.new(x, y, min_z)
    negative_space << Cube.new(x, y, min_z)

    (min_z..max_z).each do |z|
      all_space << Cube.new(x, y, z)
    end
  end
end

while !queue.empty?
  current = queue.shift

  adjacent_cubes_for(current).each do |adjacent|
    next if negative_space.include?(adjacent)
    next if adjacent.x > max_x || adjacent.y > max_y || adjacent.z > max_z
    next if adjacent.x < min_x || adjacent.y < min_y || adjacent.z < min_z

    unless cubes.include? adjacent
      queue << adjacent
      negative_space << adjacent
    end
  end
end

trapped = all_space - negative_space - cubes

# covered faces from trapped (inexistent) cubes are "exposed" faces from the real cubes
trapped_faces_covered = trapped.map do |cube|
  cubes.count { |other_cube| adjacent?(cube, other_cube) }
end.sum

faces_exposed = cubes.map do |cube|
  6 - cubes.count { |other_cube| adjacent?(cube, other_cube) }
end.sum

puts faces_exposed, trapped_faces_covered, faces_exposed - trapped_faces_covered
