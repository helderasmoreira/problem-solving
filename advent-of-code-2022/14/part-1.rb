map = Array.new(1000) { Array.new(1000, '.') }

input = File.readlines('puzzle.input', chomp: true).map do |line|
  tokens = line.split(' -> ').map { |token| token.split(',').map(&:to_i) }
  tokens.each_cons(2) do |from, to|
    xs = [from.first, to.first].sort
    ys = [from.last, to.last].sort

    ys.first.upto(ys.last).each { |y| xs.first.upto(xs.last).each { |x| map[y][x] = '#' } }
  end
end

def process(map)
  sand_at_rest = 0

  while true do
    sand_x = 500
    sand_y = 0
    sand_moving = true

    while sand_moving do
      # infinity...
      return sand_at_rest if sand_y + 1 == map.size

      if map[sand_y + 1][sand_x] == '.'
        sand_y += 1
      elsif map[sand_y + 1][sand_x - 1] == '.'
        sand_y += 1
        sand_x -= 1
      elsif map[sand_y + 1][sand_x + 1] == '.'
        sand_y += 1
        sand_x += 1
      else
        map[sand_y][sand_x] = 'o'
        sand_moving = false
        sand_at_rest += 1
      end
    end
  end
end

puts process(map)
