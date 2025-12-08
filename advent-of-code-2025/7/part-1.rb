grid = []
queue = []
direction = [1, 0]

File.readlines('puzzle-small.input', chomp: true).each do |line|
  start = line.index('S')
  queue << [0, start] if start

  grid << line.split('')
end

splits = []
until queue.empty?
  ri, ci = queue.shift

  next_position = [ri + direction.first, ci + direction.last]

  next if queue.include?(next_position)
  next if next_position.first == grid.size

  case grid[next_position.first][next_position.last]
  when '^'
    splits << [ri, ci]

    queue << [ri, ci - 1] unless queue.include?([ri, ci - 1])
    queue << [ri, ci + 1] unless queue.include?([ri, ci + 1])
  when '.'
    queue << next_position
  end
end

puts splits.uniq.size
