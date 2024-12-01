input = File.readlines('puzzle.input', chomp: true).map { |line| line.split(' | ').map { |t| t.split(' ') } }

# digits 1, 7, 4, 8
n_signals = [2, 3, 4, 7]

input.map! do |line|
  line.last.count { |n| n_signals.any? {|size| n.size == size } }
end

puts input.inspect
puts input.sum
