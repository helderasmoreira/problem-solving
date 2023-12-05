forest = File.readlines('puzzle.input', chomp: true).map { |line| line.split('').map(&:to_i) }

visible_inside = 0

1.upto(forest.size - 2) do |row|
  1.upto(forest.size - 2) do |column|
    tree = forest[row][column]

    left = (column - 1).downto(0).all? { |index| tree > forest[row][index] }
    right = (column + 1).upto(forest.size - 1).all? { |index| tree > forest[row][index] }
    up = (row - 1).downto(0).all? { |index| tree > forest[index][column] }
    down = (row + 1).upto(forest.size - 1).all? { |index| tree > forest[index][column] }

    visible_inside += 1 if up || down || left || right
  end
end

puts visible_inside + (forest.size * 2) + ((forest.size - 2) * 2)
