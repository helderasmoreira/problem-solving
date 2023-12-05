TO_KEEP = 20
N_ROCKS = 2022

jets = File.readlines('puzzle-small.input', chomp: true).map do |line|
  line.split('')
end.flatten.cycle

rocks = [
  [[1,1], [2,1], [3,1], [4,1]],
  [[1,2], [2,1], [3,2], [2,3]],
  [[1,1], [2,1], [3,1], [3,2], [3,3]],
  [[1,1], [1,2], [1,3], [1,4]],
  [[1,1], [1,2], [2,1], [2,2]]
]

$ys = { 1 => [0], 2 => [0], 3 => [0], 4 => [0], 5 => [0], 6 => [0], 7 => [0] }

def collision?(rock)
  rock.any? { |block| $ys[block.first].include? block.last  }
end

def can_move?(rock)
  rock.all? { |x, y| x <= 7 && x >= 1 && y >= 1 }
end

rock_index = 0
while true do
  rock_index += 1
  break if rock_index == (N_ROCKS + 1)
  puts rock_index

  # not really needed but helps speed it up...
  $ys.each do |_, v|
    next unless v.size > TO_KEEP
    v.shift(v.size - TO_KEEP)
  end

  falling_rock = rocks.first.map { |x, y| [x + 2, y + $ys.values.flatten.max + 3] }
  rocks.rotate!

  while true do
    jet = jets.next
    modifier = jet == '<' ? -1 : 1

    moved_by_jet = falling_rock.map { |x, y| [x + modifier, y] }
    if can_move?(moved_by_jet)
      if !collision?(moved_by_jet)
        falling_rock = moved_by_jet
      end
    end

    moved_by_gravity = falling_rock.map { |x, y| [x, y - 1] }
    if !collision?(moved_by_gravity)
      falling_rock = moved_by_gravity
    else
      falling_rock.each do |x, y|
        $ys[x] << y
      end
      break
    end
  end
end

puts $ys.values.flatten.max
