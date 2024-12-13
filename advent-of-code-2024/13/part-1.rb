require 'pry-byebug'

input = File.readlines('puzzle.input', chomp: true)

cost_a = 3
cost_b = 1

costs =
  input.each_slice(4).map do |a, b, prize, _|
    ax, ay = a.match(/Button [A-Z]: X\+(\d+), Y\+(\d+)/).captures.map(&:to_i)
    bx, by = b.match(/Button [A-Z]: X\+(\d+), Y\+(\d+)/).captures.map(&:to_i)
    px, py = prize.match(/Prize: X=(\d+), Y=(\d+)/).captures.map(&:to_i)

    min_cost = nil
    options = []
    (1..100).each do |clicks_a|
      (1..100).each do |clicks_b|
        if ((clicks_a * ax) + (clicks_b * bx)) == px && ((clicks_a * ay) + (clicks_b * by)) == py
          cost = (clicks_a * cost_a) + (clicks_b * cost_b)
          min_cost = cost if min_cost.nil? || cost < min_cost
        end
      end
    end

    min_cost
  end

puts costs.compact.sum
