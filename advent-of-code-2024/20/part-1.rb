require 'pry-byebug'

directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
start_point = nil
exit_point = nil

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

queue = [[start_point[0], start_point[1], 0, false, Set.new]]

# another time to use the cheat
# and know the time it takes to reach the exit after using it, ending the run ASAP
# see part 2 for an alternative approach: we don't **really** need to run the path again at all
times = []
until queue.empty?
  ri, ci, score, cheat_used, visited = queue.shift

  if [ri, ci] == exit_point
    times << score
    next
  end

  visited.add([ri, ci])

  if cheat_used
    times << (score + (cache[exit_point] - cache[[ri, ci]]))
    next
  end

  directions.each do |ndri, ndci|
    nri = ri + ndri
    nci = ci + ndci

    if map[nri][nci] == '#'
      next if cheat_used

      cnri = nri + ndri
      cnci = nci + ndci

      next unless cnri < map.size &&
        cnri > 0 &&
        cnci < map.first.size &&
        cnci > 0 &&
        !visited.include?([cnri, cnci]) &&
        map[cnri][cnci] != '#'

      queue.push([cnri, cnci, score + 2, true, visited.dup])
    else
      next if visited.include?([nri, nci])

      queue.push([nri, nci, score + 1, cheat_used, visited])
    end
  end
end

diffs = times.map { |t| cache[exit_point] - t }

puts diffs.count { |v| v >= 100 }
