require 'pry-byebug'

RANGE = (200_000_000_000_000..400_000_000_000_000)

lines = File.readlines('puzzle.input', chomp: true).map do |line|
  l, r = line.split(' @ ')
  l = l.split(', ').map(&:to_r)
  r = r.split(', ').map(&:to_r)

  m = ((l[1] + r[1]) - l[1]) / ((l[0] + r[0]) - l[0])
  b = l[1] - (m * l[0])

  [l, r, m, b]
end

def future?(initial_x, x, dx)
  if dx.positive?
    x >= initial_x
  else
    x < initial_x
  end
end

interceptions = lines.combination(2).count do |one, other|
  l1, r1, m1, b1 = one
  l2, r2, m2, b2 = other
  x = -(b1 - b2) / (m1 - m2)

  next unless future?(l1[0], x, r1[0])
  next unless future?(l2[0], x, r2[0])
  next unless RANGE.include?(x)

  y = m1 * x + b1
  RANGE.include?(y)
rescue ZeroDivisionError
  false
end

puts interceptions.inspect
