require 'pry-byebug'

instructions = File.readlines('puzzle.input', chomp: true).map do |line|
   _, _, hex = line.scan(/(\w) (\d+) \(#(\w+)\)/).flatten

  n = hex[0..4].to_i(16)
  direction = hex[-1].to_i(16)

  [direction, n]
end

points_edge = 0
points = [[0,0]]
r = 0
c = 0

instructions.each do |direction, n|
  points_edge += n

  case direction
  when 0
    c += n
  when 1
    r += n
  when 2
    c -= n
  when 3
    r -= n
  end

  points << [r, c]
end

# using the shoelace formula to calculate the area
area = (points).each_cons(2).map { |a, b| (a[1] * b[0]) - (b[1] * a[0]) }.sum / 2
# and then figuring out how many points are in it using Pick's theorem
points_inside = area - ((points_edge - 1) / 2)

puts points_edge + points_inside
