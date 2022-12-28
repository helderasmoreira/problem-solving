require 'pry-byebug'

TO_KEEP = 20
N_ROCKS = 1_000_000_000_000

jets = File.readlines('puzzle.input', chomp: true).map do |line|
  line.split('')
end.flatten

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
jet_index = -1

# from observing console output. could approximate further to reduce time but whatever! :-D
DELTA_ROCK_INDEX = 1720
DELTA_VALUES = 2704
TIME_TRAVEL = 581_395_344
time_traveled = false

while true do
  rock_index += 1
  break if rock_index == (N_ROCKS + 1)

  falling_rock = rocks.first.map { |x, y| [x + 2, y + $ys.values.flatten.max + 3] }
  rocks.rotate!

  while true do
    jet_index += 1
    if jet_index == jets.size
      jet_index = 0
      if !time_traveled && rock_index > 2000
        rock_index += (DELTA_ROCK_INDEX * TIME_TRAVEL)
        $ys.transform_values! { |v| v.map { |y| y + (DELTA_VALUES * TIME_TRAVEL) } }
        falling_rock = falling_rock.map { |x, y| [x, y + (DELTA_VALUES * TIME_TRAVEL)] }
        time_traveled = true
      end
    end

    jet = jets[jet_index]
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
