Coordinate = Struct.new(:x, :y, :dx, :dy)

input = File.readlines('10.input', chomp: true).map { |xy| Coordinate.new(*xy.scan(/(-?\d+)/).flatten.map(&:to_i)) }

def advance_time(input)
  input.map! { |coord| coord.x += coord.dx; coord.y += coord.dy; coord; }
end

seconds = 0
loop do
  min_y, max_y = input.map { |c| c.y }.sort.values_at(0, -1)
  break if max_y - min_y <= 12
  input = advance_time(input)
  seconds += 1
end

def print_board(input)
  min_x, max_x = input.map { |c| c.x }.sort.values_at(0, -1)
  min_y, max_y = input.map { |c| c.y }.sort.values_at(0, -1)

  min_y.upto(max_y).each do |y|
    line =
      min_x.upto(max_x).map do |x|
        input.find { |c| c.x == x && c.y == y } ? '#' : '.'
      end.join(' ')
    puts line
  end
end

puts "seconds passed: #{seconds}"
print_board(input)

