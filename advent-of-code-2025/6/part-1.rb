columns = []

File.readlines('puzzle.input', chomp: true).each do |line|
  if line.match?(/^[\s*+]+\s*$/)
    line.scan(/[*+]/).each_with_index do |operator, index|
      columns[index] << operator
    end
  else
    line.split(' ').map(&:to_i).each_with_index do |number, index|
      columns[index] ||= []
      columns[index] << number
    end
  end
end

sum = 0
columns.each do |column|
  operator = column.pop
  initial_value = operator == '*' ? 1 : 0

  total = column.inject(initial_value) do |acc, number|
    case operator
    when '*'
      acc * number
    when '+'
      acc + number
    end
  end

  sum += total
end

puts sum
