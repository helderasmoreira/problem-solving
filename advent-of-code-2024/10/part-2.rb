require 'pry-byebug'

zeroes = []

map = File.readlines('puzzle.input', chomp: true).each_with_index.map do |line, ri|
  line.split('').map(&:to_i).tap do |row|
    row.each_index do |ci|
      zeroes << [ri, ci] if row[ci].zero?
    end
  end
end

zeroes.map! do |zri, zci|
  queue = [[zri, zci, 0]]

  nines = []
  while !queue.empty?
    ri, ci, value = queue.pop

    if value == 9
      nines << [ri, ci]
    else
      [[-1, 0], [0, 1],[1, 0],[0, -1]].each do |dr, dc|
        nr = ri + dr
        nc = ci + dc

        next if nr < 0 || nr == map.size
        next if nc < 0 || nc == map.first.size

        queue << [nr, nc, value + 1] if map[nr][nc] == value + 1
      end
    end
  end

  nines.size
end

puts zeroes.sum
