input = File.readlines('puzzle.input', chomp: true).first.split(',').map(&:to_i)

days = 80

frequency = []
0.upto(8) { |n| frequency << input.count(n) }

days.times do |n|
  new_frequency = Array.new(9, 0)

  8.downto(0).each do |index|
    if index == 0
      new_frequency[8] = frequency[index]
      new_frequency[6] += frequency[index]
    else
      new_frequency[index - 1] += frequency[index]
    end
  end

  frequency = new_frequency
end

puts frequency.inspect
puts frequency.sum
