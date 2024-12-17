require 'pry-byebug'

directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
current = nil
finish = nil

maze = File.readlines('puzzle.input', chomp: true).each_with_index do |line, ri|
  line.split('').tap do |row|
    current = [ri, row.index('S')] if row.include?('S')
    finish = [ri, row.index('E')] if row.include?('E')
  end
end

queue = [[current, [0, 1], Set.new, 0]]
min_score = Float::INFINITY
visited = {}
best = Set.new

until queue.empty?
  current, direction, path, score = queue.shift
  cri, cci = current
  dri, dci = direction

  visited[[current, direction]] = score

  npath = path.dup << current

  # we're done
  if maze[cri][cci] == 'E'
    if score < min_score
      min_score = score
      best = npath
    elsif score == min_score
      npath.each { |n| best.add(n) }
    end
    next
  end

  directions.each do |ndri, ndci|
    # don't go backwards
    next if ndri == -dri && ndci == -dci

    nri = cri + ndri
    nci = cci + ndci

    next if maze[nri][nci] == '#'

    # no need to continue if we've seen it before
    # same position, same direction, lower score
    been_there = visited[[[nri, nci], [ndri, ndci]]]
    next if been_there && (score + 1) > been_there

    # no need to continue if it's already worse than best score
    next if (score + 1) > min_score

    nscore = [dri, dci] == [ndri, ndci] ? score + 1 : score + 1 + 1_000
    queue << [[nri, nci], [ndri, ndci], npath, nscore]
  end
end

puts min_score
puts best.size
puts best.sort.inspect
