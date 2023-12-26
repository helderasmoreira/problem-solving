require 'pry-byebug'
require 'set'
require 'pqueue'

REVERSE = {
  [1, 0] => [-1, 0],
  [-1, 0] => [1, 0],
  [0, 1] => [0, -1],
  [0, -1] => [0, 1],
}

grid = File.readlines('puzzle.input', chomp: true).map { |line| line.split('').map(&:to_i) }

distances = {}
visited = Set.new

# r, c, times forward, direction
to_visit = PQueue.new([[0, 0, 0, [0, 1], 0], [0, 0, 0, [1, 0], 0]]) { |one, other| one.last < other.last }

distances = Hash.new(Float::INFINITY)
distances[[0, 0, 0, [0, 1]]] = 0
distances[[0, 0, 0, [1, 0]]] = 0

while current = to_visit.pop do
  r, c, tf, d, score = current

  next if visited.include? [r, c, tf, d]
  visited << [r, c, tf, d]

  [
    [1, 0],
    [-1, 0],
    [0, 1],
    [0, -1]
  ].each do |direction|
    next if direction == REVERSE[d]

    dr, dc = direction
    nr = r + dr
    nc = c + dc
    ntf = direction == d ? tf + 1 : 1

    next if direction == d && tf == 10
    next if direction != d && tf < 4

    next if nr < 0 || nr == grid.size
    next if nc < 0 || nc == grid.first.size

    nscore = score + grid[nr][nc]
    next if distances[[nr, nc, ntf, direction]] <= nscore

    distances[[nr, nc, ntf, direction]] = nscore
    to_visit << [nr, nc, ntf, direction, nscore]
  end
end

puts distances.select { |(r, c, _, _), _| [r, c] == [grid.size - 1, grid.first.size - 1] }.values.min
