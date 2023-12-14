require 'pry-byebug'

grid = File.readlines('puzzle.input', chomp: true).map { |line| line.split('') }

initial_r = grid.flat_map.with_index { |r, r_i| r.each_index.select { |c_i| r[c_i] == 'O'}.map { |c_i| [r_i, c_i] } }
final_r = []

while current = initial_r.shift
  r, c = current

  if r - 1 < 0
    final_r << current
  elsif grid[r - 1][c] == '#'
    final_r << current
  elsif final_r.include? [r - 1, c]
    final_r << current
  else
    initial_r.unshift([r - 1, c])
  end
end

puts final_r.inject(0) { |acc, el| acc + (grid.size - el[0]) }
