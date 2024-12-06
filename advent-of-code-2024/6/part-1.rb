require 'pry-byebug'

gri = nil
gci = nil

map = File.readlines('puzzle.input', chomp: true).map.with_index do |line, ri|
  line.split('').tap do |row|
    maybe_gci = row.find_index('^')

    if maybe_gci
      gci = maybe_gci
      gri = ri
    end
  end
end

direction = [-1, 0]
directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]

n_positions = Set.new

loop do
  n_positions << [gri, gci]

  ngri = gri + direction.first
  ngci = gci + direction.last

  break if ngri == map.size || ngci == map.first.size

  if map[ngri][ngci] == '#'
    index = directions.index(direction)
    direction = directions[(index + 1) % directions.size]
  else
    gri = ngri
    gci = ngci
  end
end

puts n_positions.size
