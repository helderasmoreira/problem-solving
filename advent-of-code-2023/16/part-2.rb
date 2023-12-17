require 'pry-byebug'
require 'set'

GRID = File.readlines('puzzle.input', chomp: true).map { |line| line.split('') }

def energize(start)
  to_visit = [start]
  visited = Set.new()
  visited_no_direction = Set.new()

  while current = to_visit.shift
    r, c, direction = current
    next if r == GRID.size || r < 0
    next if c == GRID.first.size || c < 0
    next if visited.include?(current)

    visited << current
    visited_no_direction << [r, c]

    case GRID[r][c]
    when '.'
      to_visit << [r + direction[0], c + direction[1], direction]
    when '|'
      if direction[0] == 0
        to_visit << [r - 1, c, [-1, 0]]
        to_visit << [r + 1, c, [1, 0]]
      else
        to_visit << [r + direction[0], c, direction]
      end
    when '-'
      if direction[1] == 0
        to_visit << [r, c - 1, [0, -1]]
        to_visit << [r, c + 1, [0, 1]]
      else
        to_visit << [r, c + direction[1], direction]
      end
    when '\\'
      case direction
      when [0, 1]
        to_visit << [r + 1, c, [1, 0]]
      when [0, -1]
        to_visit << [r - 1, c, [-1, 0]]
      when [1, 0]
        to_visit << [r, c + 1, [0, 1]]
      when [-1, 0]
        to_visit << [r, c - 1, [0, -1]]
      end
    when '/'
      case direction
      when [0, 1]
        to_visit << [r - 1, c, [-1, 0]]
      when [0, -1]
        to_visit << [r + 1, c, [1, 0]]
      when [1, 0]
        to_visit << [r, c - 1, [0, -1]]
      when [-1, 0]
        to_visit << [r, c + 1, [0, 1]]
      end
    end
  end

  visited_no_direction
end

starts = []
0.upto(GRID.size - 1) do |i|
  starts << [0, i, [1, 0]]
  starts << [GRID.size - 1, i, [-1, 0]]
  starts << [i, 0, [0, 1]]
  starts << [i, GRID.size - 1, [0, -1]]
end

results = starts.map { |start| energize(start).count }
puts results.max
