require 'pry-byebug'

y_size = 103
x_size = 101

machines = File.readlines('puzzle.input', chomp: true).map do |line|
  line.scan(/-?\d+/).map(&:to_i)
end

n_machines = machines.size

seconds = 0

loop do
  seconds += 1
  current_unique = Set.new

  machines.map! do |px, py, vx, vy|
    current_unique << [(px + vx) % x_size, (py + vy) % y_size]
    [(px + vx) % x_size, (py + vy) % y_size, vx, vy]
  end

  break if current_unique.size == n_machines
end

puts seconds
