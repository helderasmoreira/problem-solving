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
  elsif @map[new_ri][new_ci] == 'O'
    if move(new_ri, new_ci, 'O', direction)
      @map[new_ri][new_ci] = el
      @map[ri][ci] = '.'
      true
    else
      false
    end
  end
end

File.readlines('puzzle.input', chomp: true).each_with_index do |line, ri|
  if line.start_with?('#')
    row = line.split('')

    if row.include?('@')
      rri = ri
      rci = row.index('@')
    end

    @map << row
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
    if el == 'O'
      total += 100 * ri + ci
    end
  end
end

puts total
