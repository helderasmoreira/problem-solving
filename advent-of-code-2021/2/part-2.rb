horizontal = 0
depth = 0
aim = 0

File.readlines('puzzle.input', chomp: true).each do |line|
  direction, x = line.scan(/(\w+)\s(\d+)/).first
  x = x.to_i

  case direction
  when 'forward'
    horizontal += x
    depth += (aim * x)
  when 'up'
    aim -= x
  when 'down'
    aim += x
  end
end

puts horizontal * depth
