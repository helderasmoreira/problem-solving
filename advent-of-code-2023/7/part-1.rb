require 'pry-byebug'

VALUES = {
  'A' => 14,
  'K' => 13,
  'Q' => 12,
  'J' => 11,
  'T' => 10
}.freeze

hands = File.readlines('puzzle.input', chomp: true).map do |line|
  hand, score = line.split(' ')
  score = score.to_i
  hand = hand.split('').map { |value| VALUES.fetch(value, value.to_i) }

  [hand, score]
end

sorted_hands = hands.sort do |(one, _), (other, _)|
  strength_one = one.tally.values.sort.reverse
  strength_other = other.tally.values.sort.reverse

  if strength_one == strength_other
    one <=> other
  else
    strength_one <=> strength_other
  end
end

puts sorted_hands.each_with_index.inject(0) { |sum, ((_, score), index)| sum += score * (index + 1) }
