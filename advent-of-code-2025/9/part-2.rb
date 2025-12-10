def area(one, other)
  ((one[0] - other[0]).abs + 1) * ((one[1] - other[1]).abs + 1)
end

def point_in_polygon?(point)
  return @cached_in_polygon[point] if @cached_in_polygon.key?(point)

  x, y = point
  inside = false

  @edges.each do |(xi, yi), (xj, yj)|
    # check if on the edge
    if yi == yj && yi == y
      x_min, x_max = xi < xj ? [xi, xj] : [xj, xi]
      if x.between?(x_min, x_max)
        @cached_in_polygon[point] = true
        return true
      end
    elsif xi == xj && xi == x
      y_min, y_max = yi < yj ? [yi, yj] : [yj, yi]
      if y.between?(y_min, y_max)
        @cached_in_polygon[point] = true
        return true
      end
    end

    # ray casting to check if inside/outside
    if ((yi > y) != (yj > y))
      x_intersection = (xj - xi) * (y - yi).to_f / (yj - yi) + xi
      if x <= x_intersection
        inside = !inside
      end
    end
  end

  @cached_in_polygon[point] = inside
  inside
end

@tiles = []
@cached_in_polygon = {}

File.readlines('puzzle.input', chomp: true).each do |line|
  x, y = line.split(',').map(&:to_i)
  @tiles << [x, y]
end

@edges = @tiles.each_cons(2).to_a + [[@tiles.last, @tiles.first]]

winner =
  @tiles.combination(2)
    .sort_by { |one, other| -area(one, other) }
    .find do |one, other|
      x1, x2 = one[0], other[0]
      y1, y2 = one[1], other[1]
      x_range = x1 < x2 ? (x1..x2) : (x2..x1)
      y_range = y1 < y2 ? (y1..y2) : (y2..y1)

      # checking the corners of the rectangle
      next unless point_in_polygon?([x_range.min, y_range.min]) &&
                  point_in_polygon?([x_range.min, y_range.max]) &&
                  point_in_polygon?([x_range.max, y_range.min]) &&
                  point_in_polygon?([x_range.max, y_range.max])

      # checking all of points in the perimeter
      next unless x_range.all? { |x| point_in_polygon?([x, y_range.min]) } # top
      next unless x_range.all? { |x| point_in_polygon?([x, y_range.max]) } # bottom
      next unless y_range.all? { |y| point_in_polygon?([x_range.min, y]) } # left
      next unless y_range.all? { |y| point_in_polygon?([x_range.max, y]) } # right

      true
    end

puts winner.inspect
puts area(winner[0], winner[1])
