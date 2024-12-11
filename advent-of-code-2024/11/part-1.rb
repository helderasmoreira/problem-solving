require 'pry-byebug'

stones = File.readlines('puzzle-small.input', chomp: true).first.split(' ').map(&:to_i)

(1..25).each do |i|
  new_stones = []

  stones.each do |stone|
    digits = stone.digits.reverse

    if stone.zero?
      new_stones << 1
    elsif digits.size.even?
      midpoint = digits.size / 2
      new_stones << digits[0...midpoint].join.to_i
      new_stones << digits[midpoint..].join.to_i
    else
      new_stones << stone * 2024
    end
  end

  stones = new_stones
end

puts stones.size
