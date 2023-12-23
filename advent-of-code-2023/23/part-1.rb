require 'pry-byebug'
require 'set'

GRID = File.readlines('puzzle.input', chomp: true).map { |line| line.split('') }
FINISH = [GRID.size - 2, GRID.first.size - 2]

def options(r, c)
  case GRID[r][c]
  when '.'
    [].tap do |options|
      options << [r + 1, c] if GRID[r + 1][c] != '#'
      options << [r - 1, c] if GRID[r - 1][c] != '#'
      options << [r, c + 1] if GRID[r][c + 1] != '#'
      options << [r, c - 1] if GRID[r][c - 1] != '#'
    end
  when '>'
    [[r, c + 1]]
  when '<'
    [[r, c - 1]]
  when '^'
    [[r - 1, c]]
  when 'v'
    [[r + 1, c]]
  end
end

# r, c, visited
to_visit = [[1, 1, Set.new]]
finals = []

while current = to_visit.shift
  r, c, visited = current

  if [r, c] == FINISH
    finals << current
    next
  end

  options = options(r, c)
  options.each do |nr, nc|
    next if visited.include? [nr, nc]

    to_visit << [nr, nc, visited.clone << [r, c]]
  end
end

sizes = finals.map { |_, _, visited| visited.size }
puts sizes.max + 2
