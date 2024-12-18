require 'pry-byebug'

@directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
@map = File.readlines('puzzle.input', chomp: true).map { |line| line.split('') }
@visited = Array.new(@map.size) { Array.new(@map.first.size, false) }

def flood_fill(ri, ci, color)
  return [0, 1] if ri.negative? || ri == @map.size || ci.negative? || ci == @map.first.size
  return [0, 1] if @map[ri][ci] != color
  return [0, 0] if @visited[ri][ci]

  @visited[ri][ci] = true

  area = 1
  perimeter = 0

  @directions.each do |dr, dc|
    sub_area, sub_perimeter = flood_fill(ri + dr, ci + dc, color)

    area += sub_area
    perimeter += sub_perimeter
  end

  [area, perimeter]
end

areas = []
perimeters = []

@visited.each_with_index do |row, ri|
  row.each_with_index do |visited, ci|
    next if visited

    area, perimeter = flood_fill(ri, ci, @map[ri][ci])

    areas << area
    perimeters << perimeter
  end
end

puts areas.zip(perimeters).map { |area, perimeter| area * perimeter }.sum
