require 'pry-byebug'

total = 0
File.readlines('puzzle.input', chomp: true).each_with_index do |game, index|
  sets = game.scan(/(?:Game \d+: )?((?:\d+\s\w+,\s*)*\d+\s\w+)/).flatten
  max = Hash.new(0)

  sets.each do |set|
    set.split(', ').each do |cube|
      n, colour = cube.split(' ')
      max[colour] = n.to_i if n.to_i > max[colour]
    end
  end

  total += (max['red'] * max['green'] * max['blue'])
end

puts total
