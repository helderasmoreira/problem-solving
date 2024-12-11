require 'pry-byebug'

stones_count = {}
File.readlines('puzzle.input', chomp: true).first.split(' ').map(&:to_i).each { |stone| stones_count[stone] = 1 }

# Not really needed but we can avoid calculating the stones for stone number N each time...
# This is here because this was my first attempt at speeding it up. It was not enough though...
@cache = {}
def stones_for(stone)
  @cache[stone] ||= begin
    digits = stone.digits.reverse
    if stone.zero?
      [1]
    elsif digits.size.even?
      midpoint = digits.size / 2
      [digits[0...midpoint].join.to_i, digits[midpoint..].join.to_i]
    else
      [stone * 2024]
    end
  end
end

(1..75).each do |i|
  new_stones_count = {}

  stones_count.each do |k, v|
    next if v == 0

    stones_for(k).each do |new_stone|
      new_stones_count[new_stone] ||= 0
      new_stones_count[new_stone] += v
    end
  end

  stones_count = new_stones_count
end

puts stones_count.values.sum
