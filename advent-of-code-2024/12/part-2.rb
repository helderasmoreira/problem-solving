require 'pry-byebug'

directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
diagonals_corners = [
  [[-1, -1], [-1, 0], [0, -1]],
  [[1, -1], [0, -1], [1, 0]],
  [[1, 1], [1, 0], [0, 1]],
  [[-1, 1], [-1, 0], [0, 1]]
]

map = {}

File.readlines('puzzle.input', chomp: true).each_with_index do |line, ri|
  line.split('').each_with_index do |n, ci|
    map[[ri, ci]] = n
  end
end

areas = []
corners = []

visited = Set.new

map.each do |(ri, ci), color|
  next if visited.include?([ri, ci])

  total_area = 0
  total_corners = 0

  queue = [[ri, ci]]

  until queue.empty?
    ri, ci = queue.shift
    next if visited.include?([ri, ci])

    total_area += 1

    visited.add([ri, ci])

    # While doing it initially I puzzled together that corners == sides
    # I did find it hard to pinpoint exactly how to count them, ended up leaving this for a few days
    # and came back to refactor the whole thing and this comment in Reddit unlocked it for me:
    # https://www.reddit.com/r/adventofcode/comments/1hcpyic/comment/m1q1nrj/

    # If any where both adjacent are not the same, it is a convex corner
    convex = diagonals_corners.count { |dc| dc.drop(1).all? { |(cdr, cdc)| map[[ri + cdr, ci + cdc]] != color } }

    # If any where both adjacent are the same, but diagonal is not, it is a concave corner
    concave = diagonals_corners.count { |dc| dc.drop(1).all? { |(cdr, cdc)| map[[ri + cdr, ci + cdc]] == color } && map[[ri + dc[0][0], ci + dc[0][1]]] != color }

    total_corners += convex
    total_corners += concave

    directions.each do |dr, dc|
      nr, nc = ri + dr, ci + dc

      queue << [nr, nc] if map[[nr, nc]] == color && !visited.include?([nr, nc])
    end
  end

  areas << total_area
  corners << total_corners
end

puts areas.zip(corners).map { |area, corner| area * corner }.sum
