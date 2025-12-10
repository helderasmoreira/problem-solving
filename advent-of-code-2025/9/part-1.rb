tiles = []

File.readlines('puzzle.input', chomp: true).each do |line|
  x, y = line.split(',').map(&:to_i)
  tiles << [x, y]
end

max_area = 0
tiles.combination(2).each do |one, other|
  area = (one[0] - other[0] + 1).abs * (one[1] - other[1] + 1).abs

  max_area = area if area > max_area
end

puts max_area
