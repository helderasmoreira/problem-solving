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

heatmap = {}
1000.times do |i|
  new_points = Set.new
  points.each do |point|
    r_i, c_i = point

    DIRECTIONS.each do |r_delta, c_delta|
      new_point = [r_i + r_delta, c_i + c_delta]
      new_point_mod = [(r_i + r_delta) % max_r, (c_i + c_delta) % max_c]

      new_points << new_point unless rocks.include? new_point_mod
    end
  end

  points = new_points
  heatmap = points.map { |r, c| [r % max_r, c % max_c] }.tally
  p [i, heatmap.values.sort.tally]
end

p points.size
p heatmap.values.sort.tally.map { |k, v| k * v }.sum

# By running this for a while it's possible to find a cycle every 131 iterations with 3 keys
# Those 3 keys can be extrapolated for further iterations:
# First key: cycle ** 2
# Second key: (cycle ** 2 + cycle)
# Third key: (cycle + 1) ** 2
#
# Using this formula it's possible to calculate the final value
# 26501365 / 131 = 202300 - number of complete cycles
# 26501365 % 131 = 65 - number of iterations in the last incomplete cycle
# Grabbing the multipliers from iteration 65 of the cycle:
# 202300**2 * 3758 + (202300**2 + 202300)*7580 + ((202300+1)**2) * 3848
# 621494544278648
