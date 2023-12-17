require 'pry-byebug'
require 'set'

grid = File.readlines('puzzle.input', chomp: true).map { |line| line.split('') }

to_visit = [[0, 0, [0, 1]]]
visited = Set.new()
visited_no_direction = Set.new()

while current = to_visit.shift
  r, c, direction = current
  next if r == grid.size || r < 0
  next if c == grid.first.size || c < 0
  next if visited.include?(current)

  visited << current
  visited_no_direction << [r, c]

  case grid[r][c]
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

puts visited_no_direction.count
