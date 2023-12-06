require 'pry-byebug'

total = 0

File.readlines('puzzle.input', chomp: true).each_with_index do |line, index|
  winning, mine = line.split(': ').last.split(' | ').map { |side| side.split(' ') }

  mine_winning = mine.intersection(winning)
  total += (2 ** (mine_winning.size - 1)) if mine_winning.any?
end

puts total
