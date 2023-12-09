require 'pry-byebug'

def difference(numbers)
  return 0 if numbers.uniq.size == 1

  new_numbers = numbers.each_cons(2).map { |one, other| other - one }
  new_numbers.last + difference(new_numbers)
end

values = File.readlines('puzzle.input', chomp: true).map do |line|
  numbers = line.split(' ').map(&:to_i)
  numbers.last + difference(numbers)
end

puts values.reduce(:+)
