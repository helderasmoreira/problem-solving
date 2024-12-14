require 'pry-byebug'

y_size = 103
x_size = 101

machines = File.readlines('puzzle.input', chomp: true).map do |line|
  line.scan(/-?\d+/).map(&:to_i)
end

1.upto(100) do |second|
  machines.map! do |px, py, vx, vy|
    [(px + vx) % x_size, (py + vy) % y_size, vx, vy]
  end
end

by_quadrant = [[], [], [], []]

machines.each do |px, py, vx, vy|
  if px < (x_size / 2) && py < (y_size / 2)
    by_quadrant[0] << [px, py, vx, vy]
  elsif px >= (x_size / 2 + 1) && py < (y_size / 2)
    by_quadrant[1] << [px, py, vx, vy]
  elsif px < (x_size / 2) && py >= (y_size / 2 + 1)
    by_quadrant[2] << [px, py, vx, vy]
  elsif px >= (x_size / 2 + 1) && py >= (y_size / 2 + 1)
    by_quadrant[3] << [px, py, vx, vy]
  end
end

puts "by_quadrant: #{by_quadrant.map(&:size)}"
puts by_quadrant.map(&:size).inject(:*)
