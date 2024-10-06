input = File.readlines('puzzle.input', chomp: true).map { |n| n.split('') }
transposed = input.transpose

gamma = transposed.map { |n| n.max_by { |i| n.count(i) } }
epsilon = transposed.map { |n| n.min_by { |i| n.count(i) } }

puts gamma.join.to_i(2) * epsilon.join.to_i(2)
