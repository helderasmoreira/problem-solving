require 'pry-byebug'

input = File.readlines('puzzle.input', chomp: true)

cost_a = 3
cost_b = 1

costs =
  input.each_slice(4).map do |a, b, prize, _|
    ax, ay = a.match(/Button [A-Z]: X\+(\d+), Y\+(\d+)/).captures.map { |n| Rational(n.to_i) }
    bx, by = b.match(/Button [A-Z]: X\+(\d+), Y\+(\d+)/).captures.map { |n| Rational(n.to_i) }
    px, py = prize.match(/Prize: X=(\d+), Y=(\d+)/).captures.map { |n| Rational(n.to_i) }

    px = 10000000000000 + px
    py = 10000000000000 + py

    clicks_y = Rational((py-(ay/ax)*px)/(by-(bx*ay)/ax))
    clicks_x = Rational((px-bx*clicks_y)/ax)

    (clicks_x.to_i * cost_a) + (clicks_y.to_i * cost_b) if clicks_y == clicks_y.to_i && clicks_x == clicks_x.to_i
  end

puts costs.inspect
puts costs.compact.sum
