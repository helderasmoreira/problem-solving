position = 50
zeroes = 0

File.readlines('puzzle.input', chomp: true).each do |line|
  number = line[1..-1].to_i
  direction = line.start_with?('L') ? -1 : 1

  position = position + (direction * number)
  position %= 100

  if position.zero?
    zeroes += 1
  end
end

puts zeroes
