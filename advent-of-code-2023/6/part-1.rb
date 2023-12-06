require 'pry-byebug'

lines = File.readlines('puzzle.input', chomp: true)

races = lines.first.scan(/(\d+)/).flatten.map(&:to_i)
records = lines.last.scan(/(\d+)/).flatten.map(&:to_i)

puts races.zip(records).inject(1) { |ways, race|
  race_ways = 0.upto(race[0]).count { |second| ((race[0] - second) * second) > race[1] }
  ways * race_ways
}
