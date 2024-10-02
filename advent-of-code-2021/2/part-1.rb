horizontal = 0
depth = 0

File.readlines('puzzle.input', chomp: true).each do |line|
  direction, x = line.scan(/(\w+)\s(\d+)/).first
  x = x.to_i

  case direction
  when 'forward'
    horizontal += x
  when 'up'
    depth -= x
  when 'down'
    depth += x
  end
end

puts horizontal * depth
