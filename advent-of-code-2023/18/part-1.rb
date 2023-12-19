require 'pry-byebug'

instructions = File.readlines('puzzle.input', chomp: true).map do |line|
   direction, n, _ = line.scan(/(\w) (\d+) \(#(\w+)\)/).flatten
   [direction, n.to_i]
end

points_edge = 0
points = [[0,0]]
r = 0
c = 0

instructions.each do |direction, n|
  points_edge += n

  case direction
  when 'R'
    c += n
  when 'D'
    r += n
  when 'L'
    c -= n
  when 'U'
    r -= n
  end

  points << [r, c]
end

# using the shoelace formula to calculate the area
area = (points).each_cons(2).map { |a, b| (a[1] * b[0]) - (b[1] * a[0]) }.sum / 2
# and then figuring out how many points are in it using Pick's theorem
points_inside = area - ((points_edge - 1) / 2)

puts points_edge + points_inside
