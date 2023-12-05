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

current_face = 1
face_ranges = {
  1 => [50..99, 0..49],
  2 => [100..149, 0..49],
  3 => [50..99, 50..99],
  4 => [0..49, 100..149],
  5 => [50..99, 100..149],
  6 => [0..49, 150..199],
}

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
      new_r = (row + directions[direction_index][0])
      new_c = (column + directions[direction_index][1])

      case current_face
      when 1
        if !face_ranges[current_face][1].include? new_r
          case direction_index
          when 1
            new_face = 3
          when 3
            new_face = 6
            new_r = new_c + 100
            new_c = 0
            new_direction_index = 0

          end
        elsif !face_ranges[current_face][0].include? new_c
          case direction_index
          when 0
            new_face = 2
          when 2
            new_face = 4
            new_r = 149 - new_r
            new_c = 0
            new_direction_index = 0
          end
        end
      when 2
        if !face_ranges[current_face][1].include? new_r
          case direction_index
          when 1
            new_face = 3
            new_r = new_c - 50
            new_c = 99
            new_direction_index = 2
          when 3
            new_face = 6
            new_r += 200
            new_c -= 100
          end
        elsif !face_ranges[current_face][0].include? new_c
          case direction_index
          when 0
            new_face = 5
            new_r = 149 - new_r
            new_c = 99
            new_direction_index = 2
          when 2
            new_face = 1
          end
        end
      when 3
        if !face_ranges[current_face][1].include? new_r
          case direction_index
          when 1
            new_face = 5
          when 3
            new_face = 1
          end
        elsif !face_ranges[current_face][0].include? new_c
          case direction_index
          when 0
            new_face = 2
            new_c = new_r + 50
            new_r = 49
            new_direction_index = 3
          when 2
            new_face = 4
            new_c = new_r - 50
            new_r = 100
            new_direction_index = 1
          end
        end
      when 4
        if !face_ranges[current_face][1].include? new_r
          case direction_index
          when 1
            new_face = 6
          when 3
            new_face = 3
            new_direction_index = 0
            new_r = new_c + 50
            new_c = 50
          end
        elsif !face_ranges[current_face][0].include? new_c
          case direction_index
          when 0
            new_face = 5
          when 2
            new_face = 1
            new_r = 149 - new_r
            new_c = 50
            new_direction_index = 0
          end
        end
      when 5
        if !face_ranges[current_face][1].include? new_r
          case direction_index
          when 1
            new_face = 6
            new_direction_index = 2
            new_r = new_c + 100
            new_c = 49
          when 3
            new_face = 3
          end
        elsif !face_ranges[current_face][0].include? new_c
          case direction_index
          when 0
            new_face = 2
            new_direction_index = 2
            new_r = 149 - new_r
            new_c = 149
          when 2
            new_face = 4
          end
        end
      when 6
        if !face_ranges[current_face][1].include? new_r
          case direction_index
          when 1
            new_face = 2
            new_c = new_c + 100
            new_r = 0
          when 3
            new_face = 4
          end
        elsif !face_ranges[current_face][0].include? new_c
          case direction_index
          when 0
            new_face = 5
            new_direction_index = 3
            new_c = new_r - 100
            new_r = 149
          when 2
            new_face = 1
            new_direction_index = 1
            new_c = new_r - 100
            new_r = 0
          end
        end
      end

      new_direction_index ||= direction_index
      new_face ||= current_face

      case map[new_r][new_c]
      when '.'
        row = new_r
        column = new_c
        current_face = new_face
        direction_index = new_direction_index
      when '#'
        instruction = 0
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
