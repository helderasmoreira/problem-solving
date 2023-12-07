require 'pry-byebug'

VALUES = {
  'A' => 14,
  'K' => 13,
  'Q' => 12,
  'T' => 10,
  'J' => 1
}.freeze

def best_strength_for(hand)
  best_j = hand.reject { |v| v == 1 }.tally.max_by{ |k,v| [v, k] }&.first || 14
  new_h = hand.map { |v| v == 1 ? best_j : v }
  new_h.tally.values.sort.reverse
end

hands = File.readlines('puzzle.input', chomp: true).map do |line|
  hand, score = line.split(' ')
  score = score.to_i
  hand = hand.split('').map { |value| VALUES.fetch(value, value.to_i) }

  [hand, score]
end

sorted_hands = hands.sort do |(one, _), (other, _)|
  strength_one = best_strength_for(one)
  strength_other = best_strength_for(other)

  if strength_one == strength_other
    one <=> other
  else
    strength_one <=> strength_other
  end
end

puts sorted_hands.each_with_index.inject(0) { |sum, ((_, score), index)| sum += score * (index + 1) }
