require 'pry-byebug'

reset_gri = nil
reset_gci = nil

map = File.readlines('puzzle.input', chomp: true).map.with_index do |line, ri|
  line.split('').tap do |row|
    maybe_gci = row.find_index('^')

    if maybe_gci
      reset_gci = maybe_gci
      reset_gri = ri
    end
  end
end

reset_direction = [-1, 0]
directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]

# finding the path of the guard
path = Set.new
gri = reset_gri
gci = reset_gci
direction = reset_direction

loop do
  path << [gri, gci]

  ngri = gri + direction.first
  ngci = gci + direction.last

  break if ngri < 0 || ngci < 0 || ngri == map.size || ngci == map.first.size

  if map[ngri][ngci] == '#'
    index = directions.index(direction)
    direction = directions[(index + 1) % directions.size]
  else
    gri = ngri
    gci = ngci
  end
end

# testing every path coordinate on whether it would be a loop
# TODO: refactor and merge with the above loop?
viable_obstacles = []

path.each do |ori, oci|
  visited = Set.new
  gri = reset_gri
  gci = reset_gci
  direction = reset_direction

  loop do
    if visited.include? [gri, gci, direction]
      viable_obstacles << [ori, oci]
      break
    end

    visited << [gri, gci, direction]

    ngri = gri + direction.first
    ngci = gci + direction.last

    break if ngri < 0 || ngci < 0 || ngri == map.size || ngci == map.first.size

    if map[ngri][ngci] == '#' || [ngri, ngci] == [ori, oci]
      index = directions.index(direction)
      direction = directions[(index + 1) % directions.size]
    else
      gri = ngri
      gci = ngci
    end
  end
end

puts viable_obstacles.size
