require 'pry-byebug'

nodes = Set.new
antennas = {}

map = File.readlines('puzzle.input', chomp: true).map.with_index do |line, ri|
  line.split('').tap do |row|
    row.each_with_index do |el, ci|
      next if el == '.'

      antennas[el] ||= []
      antennas[el] << [ri, ci]
    end
  end
end

antennas.each do |k, v|
  v.combination(2).each do |(r1, c1), (r2, c2)|
    delta_r = r2 - r1
    delta_c = c2 - c1

    nodes << [r1 + delta_r * -1, c1 + delta_c * -1]
    nodes << [r2 + delta_r, c2 + delta_c]
  end
end

visible_nodes =
  nodes.select do |r, c|
    r >= 0 && c >= 0 && r < map.size && c < map.first.size
  end

puts visible_nodes.size
