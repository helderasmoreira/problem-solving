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

puts [20, 60, 100, 140, 180, 220].map { |cycle| cycle * values[cycle - 1] }.sum
