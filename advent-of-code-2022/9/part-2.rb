require 'set'

class Integer
  def sign
    [0,1,-1][self<=>0];
   end
end

Point = Struct.new(:x, :y)

points = Array.new(10) { Point.new(0,0) }
tail_positions = Set[]

def to_move_or_not_to_move(tail:, head:)
  x_distance = head.x - tail.x
  y_distance = head.y - tail.y

  move_x = false
  move_y = false

  if (x_distance.abs > 1 && y_distance != 0) || (y_distance.abs > 1 && x_distance != 0)
    move_x = true
    move_y = true
  elsif x_distance.abs > 1
    move_x = true
  elsif y_distance.abs > 1
    move_y = true
  end

  tail.x += x_distance.sign if move_x
  tail.y += y_distance.sign if move_y
end

File.readlines('puzzle.input', chomp: true).each_with_index do |line, index|
  direction, n = line.split(' ')

  1.upto(n.to_i) do
    case direction
    when 'R'
      points.first.x += 1
    when 'L'
      points.first.x -= 1
    when 'U'
      points.first.y += 1
    when 'D'
      points.first.y -= 1
    end

    1.upto(points.size - 1) do |index|
      to_move_or_not_to_move(tail: points[index], head: points[index - 1])
    end

    tail_positions.add("#{points.last.x}#{points.last.y}")
  end
end

puts tail_positions.size
