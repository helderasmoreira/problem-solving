input = File.readlines('puzzle-small.input', chomp: true)

input = input.map { |row| row.split('').map { |n| n.to_i } }

low = Set.new

input.each_with_index do |row, ri|
  row.each_with_index do |col, ci|
    if (ci + 1 == row.size || row[ci + 1] > col) &&
      (ci - 1 < 0 || row[ci - 1] > col) &&
      (ri + 1 == input.size || input[ri + 1][ci] > col) &&
      (ri - 1 < 0 || input[ri - 1][ci] > col)
      low.add([ri, ci])
    end
  end
end

basins =
  low.map do |lr, lc|
    check = [[-1, 0], [1, 0], [0, 1], [0, -1]]

    check.each do |dr, dc|
      if input
    end
  end

puts low
puts basins
