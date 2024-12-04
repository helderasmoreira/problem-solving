require 'pry-byebug'

puzzle = File.readlines('puzzle.input', chomp: true).map { |line| line.split('') }

possible = []
puzzle.each_with_index do |row, ri|
  row.each_index.select { |ci| row[ci] == 'X' }.each do |ci|
    [[-1, -1,], [-1, 0,], [-1, 1,], [0, -1,], [0, 1,], [1, -1,], [1, 0,], [1, 1,]].each do |dri, dci|
      possible << [ri, ci, dri, dci, 'X']
    end
  end
end

found = 0
possible.each do |ri, ci, dri, dci, letter|
  nri = ri + dri
  nci = ci + dci

  next if nri.negative? || nri == puzzle.size
  next if nci.negative? || nci == puzzle.first.size

  new_letter = puzzle[nri][nci]

  case letter
  when 'X'
    possible << [nri, nci, dri, dci, 'M'] if new_letter == 'M'
  when 'M'
    possible << [nri, nci, dri, dci, 'A'] if new_letter == 'A'
  when 'A'
    found += 1 if new_letter == 'S'
  end
end

puts found
