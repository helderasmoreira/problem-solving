input = File.readlines('puzzle.input', chomp: true).map { |line| line.split(',') }

parsed_input = input.map { |pairs| pairs.map { |pair| pair.split('-').map(&:to_i) } }

fully_cover = parsed_input.select do |pairs|
  one = pairs.first.first..pairs.first.last
  another = pairs.last.first..pairs.last.last

  one.cover?(another) || another.cover?(one)
end

puts fully_cover.count
