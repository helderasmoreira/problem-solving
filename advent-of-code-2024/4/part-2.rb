require 'pry-byebug'

puzzle = File.readlines('puzzle.input', chomp: true).map { |line| line.split('') }

possible = []
puzzle.each_with_index do |row, ri|
  row.each_index.select { |ci| row[ci] == 'M' }.each do |ci|
    [[-1, -1,], [-1, 0,], [-1, 1,], [0, -1,], [0, 1,], [1, -1,], [1, 0,], [1, 1,]].each do |dri, dci|
      possible << [ri, ci, dri, dci, 'M']
    end
  end
end

found = []
possible.each do |ri, ci, dri, dci, letter|
  nri = ri + dri
  nci = ci + dci

  next if nri.negative? || nri == puzzle.size
  next if nci.negative? || nci == puzzle.first.size

  new_letter = puzzle[nri][nci]

  case letter
  when 'M'
    possible << [nri, nci, dri, dci, 'A'] if new_letter == 'A'
  when 'A'
    found << [ri, ci] if new_letter == 'S' && !dri.zero? && !dci.zero?
  end
end

puts found.tally.select { |_, count| count == 2 }.count
