x = 1
values = []

File.readlines('puzzle.input', chomp: true).each do |line|
  command, n = line.split(' ')

  case command
  when 'noop'
    values.concat([x])
  when 'addx'
    values.concat([x, x])
    x += n.to_i
  end
end

pixels = []

values.each_with_index do |value, index|
  pixel = ((value - 1)..(value + 1)).include?(index % 40) ? '#' : '.'
  pixels << pixel
end

puts pixels.each_slice(40) { |slice| puts slice.join }

