require 'set'

DIRECTIONS = { '>' => [0, 1], '<' => [0, -1], 'v' => [1, 0], '^' => [-1, 0] }.freeze
$width = nil
$height = -1

initial_blizzards = Set.new
File.readlines('puzzle.input', chomp: true).each_with_index.map do |line, row|
  next if row.zero?

  $width ||= line.size - 2
  $height += 1

  i = -1
  while (i = line.index(/[><v^]/, i + 1))
    initial_blizzards.add([[row - 1, i - 1], DIRECTIONS[line[i]]])
  end
end

$out = [$height, $width - 1]
$start = [-1, 0]
$goal = $out

blizzard_positions = [initial_blizzards.map(&:first).to_set]
blizzard_full_data = [initial_blizzards]

def blizzards_at(blizzard_full_data, blizzard_positions, minute)
  return blizzard_positions[minute] if blizzard_positions.size > minute

  (blizzard_positions.size..minute).each do |new_minute|
    updated_blizzards = blizzard_full_data[new_minute - 1].map do |blizzard|
      position = [
        (blizzard.first.first + blizzard.last.first) % $height,
        (blizzard.first.last + blizzard.last.last) % $width
      ]

      [
        position,
        blizzard.last
      ]
    end

    blizzard_full_data.push(updated_blizzards)
    blizzard_positions.push(updated_blizzards.map(&:first).to_set)
  end

  blizzard_positions[minute]
end

def possible_positions(position, time, blizzard_full_data, blizzard_positions)
  [
    [position.first, position.last + 1],
    [position.first + 1, position.last],
    [position.first-  1, position.last],
    [position.first, position.last - 1],
    [position.first, position.last],
  ].select do |row, column|
    next true if [row, column] == $out
    next true if [row, column] == $start

    row < $height &&
    row >= 0 &&
    column < $width &&
    column >= 0 &&
    !blizzards_at(blizzard_full_data, blizzard_positions, time).include?([row, column])
  end
end

queue = [
  [
    [-1, 0],    # position
    0,          # time
  ]
]

seen = Set.new

times = []
trips = 0

while queue.any?
  current, time, path = queue.shift

  if current == $goal
    times << time

    case $goal
    when $out
      $goal = $start
      queue = [[$out, 0]]
    when $start
      $goal = $out
      queue = [[$start, 0]]
    end

    trips += 1
    puts time
    break if trips == 3
  end

  next if seen.include? [current, time]
  seen.add([current, time])

  to_explore = possible_positions(current, time + 1, blizzard_full_data, blizzard_positions)
  to_explore.each do |position|
    queue.push([position, time + 1])
  end
end

