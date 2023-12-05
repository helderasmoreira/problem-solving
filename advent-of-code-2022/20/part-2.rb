require 'pry-byebug'

ENCRYPTION_KEY = 811_589_153

encrypted = File.readlines('puzzle.input', chomp: true).each_with_index.map do |line, index|
  [line.to_i * ENCRYPTION_KEY, index]
end

mixed = encrypted.clone

10.times do
  encrypted.each do |pair|
    index_to_move = mixed.index(pair)
    number_to_move, = mixed[index_to_move]

    element = mixed.delete_at(index_to_move)
    mixed.insert((index_to_move + number_to_move) % mixed.size, element)
  end
end

zero_index = mixed.find_index { |number, _| number.zero? }

x = mixed[(zero_index + 1000) % mixed.size][0]
y = mixed[(zero_index + 2000) % mixed.size][0]
z = mixed[(zero_index + 3000) % mixed.size][0]

p x, y, z, x + y + z
