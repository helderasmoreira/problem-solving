sum = 0
SIZE = 12

File.readlines('puzzle.input', chomp: true).each do |line|
  batteries = line.split('').map(&:to_i)

  number = []
  last_index = -1

  SIZE.times do
    max_value = -1
    max_index = nil

    ((last_index + 1)..(batteries.size - 1)).each do |index|
      # not enough to the right to form the number
      break if batteries.size - index < (SIZE - number.size)

      if batteries[index] > max_value
        max_value = batteries[index]
        max_index = index
      end
    end

    number << max_value
    last_index = max_index
  end

  sum += number.join.to_i
end

puts sum
