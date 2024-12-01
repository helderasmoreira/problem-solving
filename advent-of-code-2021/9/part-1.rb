input = File.readlines('puzzle.input', chomp: true)

input = input.map { |row| row.split('').map { |n| n.to_i } }

low = []

input.each_with_index do |row, ri|
  row.each_with_index do |col, ci|
    if (ci + 1 == row.size || row[ci + 1] > col) &&
      (ci - 1 < 0 || row[ci - 1] > col) &&
      (ri + 1 == input.size || input[ri + 1][ci] > col) &&
      (ri - 1 < 0 || input[ri - 1][ci] > col)
      low << col
    end
  end
end

puts low.map { |x| x + 1 }.sum
