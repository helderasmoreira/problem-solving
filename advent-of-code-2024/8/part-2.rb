require 'pry-byebug'

nodes = Set.new
antennas = {}

map = File.readlines('puzzle.input', chomp: true).map.with_index do |line, ri|
  line.split('').tap do |row|
    row.each_with_index do |el, ci|
      next if el == '.'

      antennas[el] ||= []
      antennas[el] << [ri, ci]
      nodes << [ri, ci]
    end
  end
end

antennas.each do |k, v|
  v.combination(2).each do |(r1, c1), (r2, c2)|
    delta_r = r2 - r1
    delta_c = c2 - c1

    (1..).each do |i|
      nr = r1 + delta_r * -i
      nc = c1 + delta_c * -i

      break if nr < 0 || nr >= map.size
      break if nc < 0 || nc >= map.first.size

      nodes << [nr, nc]
    end

    (1..).each do |i|
      nr = r2 + delta_r * i
      nc = c2 + delta_c * i

      break if nr < 0 || nr >= map.size
      break if nc < 0 || nc >= map.first.size

      nodes << [nr, nc]
    end
  end
end

puts nodes.size
