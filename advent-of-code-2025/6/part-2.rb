grid = []

File.readlines('puzzle.input', chomp: true).each do |line|
  grid << line.split('')
end

# Make sure the empty spaces at the end of rows are not trimmed by the editor
# otherwise the transpose would need some extra logic to ensure all rows have the same length
rotated = grid.transpose

# Add a row of empty spaces to the end of the grid to ensure we process that last set
rotated << [' ']

sum = 0
current_set = []

rotated.each do |row|
  if row.all? { |cell| cell == ' ' }
    operator = current_set.first.pop
    initial_value = operator == '*' ? 1 : 0

    total = current_set.inject(initial_value) do |acc, number|
      case operator
      when '*'
        acc * (number.join.to_i)
      when '+'
        acc + (number.join.to_i)
      end
    end

    sum += total
    current_set = []
  else
    current_set << row
  end
end

puts sum.inspect
