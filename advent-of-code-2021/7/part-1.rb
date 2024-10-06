input = File.readlines('puzzle.input', chomp: true).first.split(',').map(&:to_i)

min_delta = nil
position = nil

input.min.upto(input.max) do |n|
  delta = input.inject(0) { |sum, number| sum += (n - number).abs }

  if min_delta.nil? || delta < min_delta
    min_delta = delta
    position = n
  end
end

puts min_delta
puts position