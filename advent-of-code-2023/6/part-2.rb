require 'pry-byebug'

lines = File.readlines('puzzle.input', chomp: true)

race = lines.first.tr('^0-9', '').to_i
record = lines.last.tr('^0-9', '').to_i

puts 0.upto(race).count { |second| (race - second) * second > record }
