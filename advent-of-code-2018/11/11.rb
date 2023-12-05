# TIL https://en.wikipedia.org/wiki/Summed-area_table

require 'benchmark'

MaxScore = Struct.new(:x, :y, :value, :grid_size)
SERIAL_NUMBER = 1723
SIZE = 300

def power_level(x, y)
  rack_id = x + 10
  ((rack_id * y + SERIAL_NUMBER) * rack_id).to_s.chars[-3].to_i - 5
end

def calculate_best_3_table
  table = Array.new(SIZE + 1) { Array.new(SIZE + 1, 0) }
  1.upto(SIZE) do |y|
    1.upto(SIZE) do |x|
      table[y][x] =
        power_level(x, y) + power_level(x + 1, y) + power_level(x + 2, y) +
        power_level(x, y + 1) + power_level(x + 1, y + 1) + power_level(x + 2, y + 1) +
        power_level(x, y + 2) + power_level(x + 1, y + 2) + power_level(x + 2, y + 2)
    end
  end
  table
end

def find_max(table)
  max = nil
  1.upto(SIZE) do |y|
    1.upto(SIZE) do |x|
      if max.nil? || table[y][x] > max.value
        max = MaxScore.new(x, y, table[y][x], 3)
      end
    end
  end
  max
end

####### 2nd part #######

def calculate_summed_area_table
  table = Array.new(SIZE + 1) { Array.new(SIZE + 1, 0) }
  1.upto(SIZE) do |y|
    1.upto(SIZE) do |x|
      table[y][x] =
        power_level(x, y) +
        table.fetch(y, []).fetch(x - 1, 0) +
        table.fetch(y - 1, []).fetch(x, 0) -
        table.fetch(y - 1, []).fetch(x - 1, 0)
    end
  end
  table
end

def find_max_any_size(table)
  max = nil
  1.upto(SIZE) do |y|
    1.upto(SIZE) do |x|
      0.upto( [SIZE - y, SIZE - x].min ) do |grid_size|
        value =
          table[y + grid_size][x + grid_size] +
          table[y - 1][x - 1] -
          table[y - 1][x + grid_size] -
          table[y + grid_size][x - 1]

        if max.nil? || value > max.value
          max = MaxScore.new(x, y, value, grid_size + 1)
        end
      end
    end
  end
  max
end

puts "part-1"
puts Benchmark.measure { puts find_max(calculate_best_3_table) }
puts "part-2"
puts Benchmark.measure { puts find_max_any_size(calculate_summed_area_table) }
