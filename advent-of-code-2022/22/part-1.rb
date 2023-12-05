input = File.readlines('puzzle.input', chomp: true)

map = input[0..-3]
instructions = []

i = 0
while i < input.last.size - 1
  number = 0
  while digit = Integer(input.last[i]) rescue nil
    number = number * 10 + digit
    i += 1
  end

  instructions << number
  instructions << input.last[i] if input.last[i]

  i += 1
end

# right, down, left, up
directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]

row = 0
column = map.first.index(/[.#]/)

direction_index = 0
instructions.each do |instruction|
  case instruction
  when 'R'
    direction_index += 1
    direction_index = direction_index % 4
  when 'L'
    direction_index -= 1
    direction_index = direction_index % 4
  else
    while instruction > 0
      new_r = (row + directions[direction_index][0]) % map.size
      new_c = (column + directions[direction_index][1]) % map[row].size

      case map[new_r][new_c]
      when '.'
        row = new_r
        column = new_c
      when '#'
        instruction = 0
      else
        # travel through void
        while !['.', '#'].include? map[new_r][new_c] do
          new_r = (new_r + directions[direction_index][0]) % map.size
          new_c = (new_c + directions[direction_index][1]) % map[row].size
        end

        case map[new_r][new_c]
        when '.'
          row = new_r
          column = new_c
        when '#'
          instruction = 0
        end
      end

      instruction -= 1
    end
  end
end

puts "direction #{direction_index}"
puts "row #{row}"
puts "column #{column}"
puts '---'
puts 1_000 * (row + 1) + 4 * (column + 1) + direction_index
