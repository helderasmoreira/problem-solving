require 'pry-byebug'

map = File.readlines('puzzle.input', chomp: true).map { |line| line.split('') }

e_r = 0.upto(map.first.size - 1).select { |r_i| map[r_i].none? { |x| x == '#' } }
e_c = 0.upto(map.first.size - 1).select { |c_i| map.none? { |r| r[c_i] == '#' } }

galaxies = map.flat_map.with_index do |r, r_i|
  0.upto(r.size).select { |i| r[i] == '#' }.map do |c_i|
    r_delta = e_r.count { |x| x <= r_i }
    c_delta = e_c.count { |x| x <= c_i }

    [r_i + (r_delta * (1_000_000 - 1)), c_i + (c_delta * (1_000_000 - 1))]
  end
end

puts galaxies.combination(2).map { |a, b| (a[1] - b[1]).abs + (a[0] - b[0]).abs }.sum
