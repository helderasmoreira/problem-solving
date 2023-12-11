require 'pry-byebug'
require 'set'

def shoelace_area(path)
  path.each_cons(2).map { |a, b| (a[1] * b[0]) - (b[1] * a[0]) }.sum / 2
end

to_visit = []
map = File.readlines('puzzle.input', chomp: true).map.with_index do |line, y|
  line.split('').then do |line|
    sx = line.index('S')
    to_visit << [y + 1, sx + 1] if sx

    ['.'] + line + ['.']
  end
end

map.unshift(Array.new(map.first.size, '.'))
map << Array.new(map.first.size, '.')

visited = Set.new
while current = to_visit.shift
  y, x = current
  next if visited.include? [y, x]

  visited << [y, x]

  case map[y][x]
  when 'S'
    to_visit << [y - 1, x] if ['|', '7', 'F'].include? map[y - 1][x]
    to_visit << [y + 1, x] if ['|', 'L', 'J'].include? map[y + 1][x]
    to_visit << [y, x - 1] if ['-', 'L', 'F'].include? map[y][x - 1]
    to_visit << [y, x + 1] if ['-', 'J', '7'].include? map[y][x + 1]
  when '-'
    to_visit += [[y, x + 1], [y, x - 1]]
  when '|'
    to_visit += [[y + 1, x], [y - 1, x]]
  when 'L'
    to_visit += [[y - 1, x], [y, x + 1]]
  when 'J'
    to_visit += [[y - 1, x], [y, x - 1]]
  when '7'
    to_visit += [[y + 1, x], [y, x - 1]]
  when 'F'
    to_visit += [[y + 1, x], [y, x + 1]]
  end
end

# using the Shoelace formula for calculating the area
fh, sh = visited.to_a[1..].partition.with_index { |_, i| i.even? }
cc_path = ([visited.first] + fh + sh.reverse + [visited.first]).compact
area = shoelace_area(cc_path).abs

# and then figuring out how many points are in it using Pick's theorem
puts area - ((cc_path.size - 1) / 2) + 1
