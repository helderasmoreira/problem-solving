forest = File.readlines('puzzle.input', chomp: true).map { |line| line.split('').map(&:to_i) }

best_scenic_score = 0

1.upto(forest.size - 2) do |row|
  1.upto(forest.size - 2) do |column|
    tree = forest[row][column]

    left = (column - 1).downto(0).inject(0) { |trees, index| break trees + 1 if tree <= forest[row][index]; trees + 1 }
    right = (column + 1).upto(forest.size - 1).inject(0) { |trees, index| break trees + 1 if tree <= forest[row][index]; trees + 1 }
    up = (row - 1).downto(0).inject(0) { |trees, index| break trees + 1 if tree <= forest[index][column]; trees + 1 }
    down = (row + 1).upto(forest.size - 1).inject(0) { |trees, index| break trees + 1 if tree <= forest[index][column]; trees + 1 }

    scenic_score = up * down * left * right
    best_scenic_score = scenic_score if scenic_score > best_scenic_score
  end
end

puts best_scenic_score
