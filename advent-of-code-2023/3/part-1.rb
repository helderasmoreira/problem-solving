require 'pry-byebug'
require 'ostruct'

# NOTE
# I could have spent time refactoring and cleaning this up... but I chose to go and play with my daughter instead!
# :-)

map = []
numbers = []

def symbol?(character)
  character =~ /[^\.\d]/
end

def adjacent_coordinates(number, map)
  range = ((number.c_index - 1)..(number.c_index + number.value.size))

  range.map { |c_value| map[number.r_index - 1][c_value] } +
  [map[number.r_index][number.c_index - 1]] +
  [map[number.r_index][number.c_index + number.value.size]] +
  range.map { |c_value| map[number.r_index + 1][c_value] }
end

def symbol_adjacent?(number, map)
  adjacent_coordinates(number, map).any? { |value| symbol?(value) }
end

File.readlines('puzzle.input', chomp: true).each_with_index do |line, r_index|
  row = ['.']

  number = nil
  line.each_char.with_index do |character, c_index|
    row << character

    if character =~ /[0-9]/
      if number.nil?
        number = OpenStruct.new(
          r_index: r_index + 1,
          c_index: c_index + 1,
          value: character
        )
      else
        number.value += character
      end
    elsif number.nil?
      next
    else
      numbers << number
      number = nil
    end
  end

  if number
    numbers << number
    number = nil
  end

  row << ['.']
  map << row.flatten
end

map.unshift(Array.new(map.first.size, '.'))
map << Array.new(map.first.size, '.')

possible_numbers = numbers.select { |number| symbol_adjacent?(number, map) }
puts possible_numbers.inject(0) { |sum, number| sum + number.value.to_i }
