require 'set'

class Integer
  def sign
    [0,1,-1][self<=>0];
   end
end

Point = Struct.new(:x, :y)

head = Point.new(0, 0)
tail = Point.new(0, 0)
tail_positions = Set[]

File.readlines('puzzle.input', chomp: true).each_with_index do |line, index|
  direction, n = line.split(' ')

  1.upto(n.to_i) do
    case direction
    when 'R'
      head.x += 1
    when 'L'
      head.x -= 1
    when 'U'
      head.y += 1
    when 'D'
      head.y -= 1
    end

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

    tail_positions.add("#{tail.x}#{tail.y}")
  end
end

puts tail_positions.size
