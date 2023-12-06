require 'pry-byebug'

cards = Hash.new(0)

File.readlines('puzzle.input', chomp: true).each_with_index do |line, index|
  winning, mine = line.split(': ').last.split(' | ').map { |side| side.split(' ').map(&:to_i) }
  mine_winning = mine.intersection(winning)

  cards[index] += 1

  (index + 1..index + mine_winning.size).each do |n|
    cards[n] += cards[index]
  end
end

puts cards.values.sum
