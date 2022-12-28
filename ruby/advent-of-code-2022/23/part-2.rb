require 'set'

$elves = Set.new

File.readlines('puzzle.input', chomp: true).each_with_index do |line, row|
  i = -1
  while i = line.index('#', i + 1)
    $elves.add([row, i])
  end
end

# north, south, east, west
directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
$direction_conditions = {
  [-1, 0] => [[-1, -1], [-1, 0], [-1, 1]],
  [1, 0] => [[1, -1], [1, 0], [1, 1]],
  [0, 1] => [[-1, 1], [0, 1], [1, 1]],
  [0, -1] => [[-1, -1], [0, -1], [1, -1]]
}

def clear_around?(elf)
  [
    [elf.first - 1, elf.last - 1],
    [elf.first - 1, elf.last],
    [elf.first - 1, elf.last + 1],
    [elf.first, elf.last - 1],
    [elf.first, elf.last + 1],
    [elf.first + 1 ,elf.last - 1],
    [elf.first + 1, elf.last],
    [elf.first + 1, elf.last + 1]
  ].none? { |position| $elves.include? position }
end

def clear_in_direction?(elf, direction)
  $direction_conditions[direction].none? do |delta|
    $elves.include? [elf.first + delta.first, elf.last + delta.last]
  end
end

round = 0
while true do
  round += 1

  proposals = {}
  proposal_count = Hash.new(0)

  $elves.each do |elf|
    next if clear_around?(elf)

    directions.each do |direction|
      if clear_in_direction?(elf, direction)
        new_position = [elf.first + direction.first, elf.last + direction.last]

        proposals[elf] = new_position
        proposal_count[new_position] += 1
        break
      end
    end
  end

  move = 0
  proposals.each do |elf, proposal|
    next if proposal_count[proposal] > 1

    move += 1
    $elves.delete(elf)
    $elves.add(proposal)
  end

  break if move.zero?

  directions.rotate!
end

puts round
