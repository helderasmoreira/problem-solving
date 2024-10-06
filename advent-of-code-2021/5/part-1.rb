input =
  File.readlines('puzzle.input', chomp: true)
    .map { |row| row.split(' -> ').map { |c| c.split(',').map(&:to_i) } }

def expand(line)
  # ignoring diagnoal lines; part 2 incoming...
  return nil if line[0][0] != line[1][0] && line[0][1] != line[1][1]

  x = line[0][0].step(line[1][0], line[0][0] <= line[1][0] ? 1 : -1)
  y = line[0][1].step(line[1][1], line[0][1] <= line[1][1] ? 1 : -1)

  x.to_a.product(y.to_a)
end

expanded = input.map { |line| expand(line) }
tally = expanded.compact.flatten(1).tally

puts tally.select { |_, v| v > 1 }.size
