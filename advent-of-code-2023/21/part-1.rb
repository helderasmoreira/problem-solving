require 'pry-byebug'
require 'set'

DIRECTIONS = [[1, 0], [-1, 0], [0, 1], [0, -1]]

rocks = Set.new
points = Set.new

lines = File.readlines('puzzle.input', chomp: true)
lines.each_with_index do |line, r_i|
  (0...line.length).find_all { |i| line[i] == '#' }.each { |c_i| rocks << [r_i, c_i] }

  sc_i = line.index('S')
  points << [r_i, sc_i] if sc_i
end

max_r = lines.size
max_c = lines.first.size

64.times do
  new_points = Set.new
  points.each do |point|
    r_i, c_i = point

    DIRECTIONS.each do |r_delta, c_delta|
      new_point = [r_i + r_delta, c_i + c_delta]
      next if new_point[0] < 0 || new_point[0] == max_r
      next if new_point[1] < 0 || new_point[1] == max_c

      new_points << new_point unless rocks.include? new_point
    end
  end

  points = new_points
end

puts points.size
