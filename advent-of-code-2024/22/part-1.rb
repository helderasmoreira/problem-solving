require 'pry-byebug'

numbers = File.readlines('puzzle.input', chomp: true).map(&:to_i)

sum = 0

numbers.each do |number|
  (1..2000).each do |i|
    one = number * 64
    number = number ^ one
    number = number % 16777216

    two = (number / 32).to_i
    number = number ^ two
    number = number % 16777216

    three = number * 2048
    number = number ^ three
    number = number % 16777216

    sum += number if i == 2000
  end
end

puts sum
