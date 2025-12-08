require 'pry-byebug'

grid = []
queue = []

File.readlines('puzzle.input', chomp: true).each do |line|
  start = line.index('S')
  queue << [1, 0, start] if start

  grid << line.split('')
end

finish = []
until queue.empty?
  value, ri, ci = queue.shift

  next_position = [ri + 1, ci]
  if next_position[0] == grid.size
    finish << value
    next
  end

  case grid[next_position[0]][next_position[1]]
  when '^'
    existing_left = queue.find { |_, r, c| r == next_position[0] && c == (next_position[1] - 1) }
    existing_right = queue.find { |_, r, c| r == next_position[0] && c == (next_position[1] + 1) }

    if existing_left
      queue.delete(existing_left)
      queue << [value + existing_left[0], next_position[0], next_position[1] - 1]
    else
      queue << [value, next_position[0], next_position[1] - 1]
    end

    if existing_right
      queue.delete(existing_right)
      queue << [value + existing_right[0], next_position[0], next_position[1] + 1]
    else
      queue << [value, next_position[0], next_position[1] + 1]
    end
  when '.'
    existing_down = queue.find { |_, r, c| r == next_position[0] && c == next_position[1] }

    if existing_down
      queue.delete(existing_down)
      queue << [value + existing_down[0], *next_position]
    else
      queue << [value, *next_position]
    end
  end
end

puts finish.sum
