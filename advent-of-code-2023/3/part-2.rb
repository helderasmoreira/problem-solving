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

def number_coordinates(number)
  ((number.c_index)..(number.c_index + number.value.size - 1)).map { |c_value| [number.r_index, c_value] }
end

def adjacent_coordinates_number(number)
  range = ((number.c_index - 1)..(number.c_index + number.value.size))

  range.map { |c_value| [number.r_index - 1, c_value] } +
  [[number.r_index, number.c_index - 1]] +
  [[number.r_index, number.c_index + number.value.size]] +
  range.map { |c_value| [number.r_index + 1, c_value] }
end

def adjacent_coordinates_position(x, y)
  (y - 1..y+1).to_a.product((x - 1..x + 1).to_a)
end

def adjacent_values(number, map)
  adjacent_coordinates_number(number).map { |x, y| map[x][y] }
end

def symbol_adjacent?(number, map)
  adjacent_values(number, map).any? { |value| symbol?(value) }
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

total = 0

map.each_with_index do |row, r_index|
  row.each_with_index do |character, c_index|
    if character == '*'
      adjacent = adjacent_coordinates_position(c_index, r_index)

      x = numbers.select { |number| number_coordinates(number).intersect?(adjacent) }
      next if x.size < 2

      total += x.map(&:value).map(&:to_i).reduce(:*)
    end
  end
end

puts total
