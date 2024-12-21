require 'pry-byebug'

directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
start_point = nil
exit_point = nil

def manhattan_distance(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

map = File.readlines('puzzle.input', chomp: true).each_with_index do |line, ri|
  line.split('').tap do |row|
    start_point = [ri, row.index('S')] if row.include?('S')
    exit_point = [ri, row.index('E')] if row.include?('E')
  end
end

queue = [[start_point[0], start_point[1], 0]]
cache = {}

# one time to populate the cache and know the "scores" of each point
until queue.empty?
  ri, ci, score = queue.shift

  cache[[ri, ci]] = score

  next if [ri, ci] == exit_point

  directions.each do |ndri, ndci|
    nri = ri + ndri
    nci = ci + ndci

    next if map[nri][nci] == '#'

    next if cache.include?([nri, nci])

    queue.push([nri, nci, score + 1])
  end
end

threshold = 100
above_threshold = 0

# now we just try to connect two points of the path that are at most 20 steps away
# and that would have a joint score that's at least 100 better than the "baseline"
# I'm sure there are better ways to write this but this was my first idea and I'm sticking with it
cache.keys.each do |ri, ci|
  possible_cheats = cache.keys.select { |nri, nci| manhattan_distance([ri, ci], [nri, nci]) <= 20 }

  above_threshold += possible_cheats.count do |nri, nci|
    total_score =
      cache[[ri, ci]] +
      manhattan_distance([ri, ci], [nri, nci]) +
      ((cache[exit_point]) - cache[[nri, nci]])

    (cache[exit_point] - total_score) >= threshold
  end
end

puts above_threshold
