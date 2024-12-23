require 'pry-byebug'

directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
map = {}

File.readlines('puzzle.input', chomp: true).each_with_index do |line, ri|
  line.split('').each_with_index do |n, ci|
    map[[ri, ci]] = n
  end
end

areas = []
perimeters = []

visited = Set.new

map.each do |(ri, ci), color|
  next if visited.include?([ri, ci])

  total_area = 0
  total_perimeter = 0

  queue = [[ri, ci]]

  until queue.empty?
    ri, ci = queue.shift
    next if visited.include?([ri, ci])

    total_area += 1

    visited.add([ri, ci])

    directions.each do |dr, dc|
      nr, nc = ri + dr, ci + dc

      if map[[nr, nc]] != color
        total_perimeter += 1
      else
        queue << [nr, nc] unless visited.include?([nr, nc])
      end
    end
  end

  areas << total_area
  perimeters << total_perimeter
end

puts areas.zip(perimeters).map { |area, perimeter| area * perimeter }.sum
