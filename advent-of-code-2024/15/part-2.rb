require 'pry-byebug'

@map = []

instructions = []
rri = nil
rci = nil
directions = {
  '^' => [-1, 0],
  'v' => [1, 0],
  '<' => [0, -1],
  '>' => [0, 1]
}

def move(ri, ci, el, direction)
  new_ri = ri + direction[0]
  new_ci = ci + direction[1]

  if @map[new_ri][new_ci] == '#'
    false
  elsif @map[new_ri][new_ci] == '.'
    @map[new_ri][new_ci] = el
    @map[ri][ci] = '.'
    true
  elsif ['[', ']'].include? @map[new_ri][new_ci]
    case direction
    when [0, -1], [0, 1]
      # moving horizontally can stay the same
      if move(new_ri, new_ci, @map[new_ri][new_ci], direction)
        @map[new_ri][new_ci] = el
        @map[ri][ci] = '.'
        true
      else
        false
      end
    when [-1, 0], [1, 0]
      # moving vertically needs to change to move two at a time OR none
      if @map[new_ri][new_ci] == '['
        nri_1 = ri + direction[0]
        nci_1 = ci + direction[1]
        nri_2 = ri + direction[0]
        nci_2 = ci + direction[1] + 1
      else
        nri_1 = ri + direction[0]
        nci_1 = ci + direction[1] - 1
        nri_2 = ri + direction[0]
        nci_2 = ci + direction[1]
      end

      if move_two(nri_1, nci_1, nri_2, nci_2, direction)
        @map[new_ri][new_ci] = el
        @map[ri][ci] = '.'
        true
      else
        false
      end
    end
  end
end

def move_two(ri_1, ci_1, ri_2, ci_2, direction, move = true)
  nri_1 = ri_1 + direction[0]
  nci_1 = ci_1 + direction[1]
  nri_2 = ri_2 + direction[0]
  nci_2 = ci_2 + direction[1]

  if @map[nri_1][nci_1] == '#' || @map[nri_2][nci_2] == '#'
    false
  elsif @map[nri_1][nci_1] == '.' && @map[nri_2][nci_2] == '.'
    if move
      move(ri_1, ci_1, '[', direction)
      move(ri_2, ci_2, ']', direction)
    end
    true
  elsif @map[nri_1][nci_1] == '[' && @map[nri_2][nci_2] == ']'
    if move_two(nri_1, nci_1, nri_2, nci_2, direction, move)
      if move
        move(ri_1, ci_1, '[', direction)
        move(ri_2, ci_2, ']', direction)
      end
      true
    end
  elsif @map[nri_1][nci_1] == ']' && @map[nri_2][nci_2] == '.'
    if move_two(nri_1, nci_1 - 1, nri_1, nci_1, direction, move)
      if move
        move(ri_1, ci_1, '[', direction)
        move(ri_2, ci_2, ']', direction)
      end
      true
    end
  elsif @map[nri_1][nci_1] == '.' && @map[nri_2][nci_2] == '['
    if move_two(nri_2, nci_2, nri_2, nci_2 + 1, direction, move)
      if move
        move(ri_1, ci_1, '[', direction)
        move(ri_2, ci_2, ']', direction)
      end
      true
    end
  elsif @map[nri_1][nci_1] == ']' && @map[nri_2][nci_2] == '['
    if move_two(nri_1, nci_1 - 1, nri_1, nci_1, direction, false) && move_two(nri_2, nci_2, nri_2, nci_2 + 1, direction, false)
      move_two(nri_1, nci_1 - 1, nri_1, nci_1, direction, true)
      move_two(nri_2, nci_2, nri_2, nci_2 + 1, direction, true)

      if move
        move(ri_1, ci_1, @map[ri_1][ci_1], direction)
        move(ri_2, ci_2, @map[ri_2][ci_2], direction)
      end
      true
    end
  end
end

File.readlines('puzzle.input', chomp: true).each_with_index do |line, ri|
  if line.start_with?('#')
    row = line.split('').each_with_index.map do |el, ci|
      case el
      when '#'
        ['#', '#']
      when '.'
        ['.', '.']
      when 'O'
        ['[', ']']
      when '@'
        rri = ri
        rci = ci * 2
        ['@', '.']
      end
    end

    @map << row.flatten
  elsif line.size > 0
    instructions.push(*line.split(''))
  end
end

instructions.each do |instruction|
  direction = directions[instruction]
  if move(rri, rci, '@', direction)
    rri += direction[0]
    rci += direction[1]
  end
end

total = 0
@map.each_with_index do |row, ri|
  row.each_with_index do |el, ci|
    if el == '['
      total += 100 * ri + ci
    end
  end
end

puts total
