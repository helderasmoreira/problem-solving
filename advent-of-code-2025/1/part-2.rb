position = 50
zeroes = 0

File.readlines('puzzle.input', chomp: true).each do |line|
  number = line[1..-1].to_i
  direction = line.start_with?('L') ? -1 : 1

  number.times do
    position = position + direction

    position = 0 if position > 99
    position = 99 if position < 0

    if position.zero?
      zeroes += 1
    end
  end
end

puts zeroes
