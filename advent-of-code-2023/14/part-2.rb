require 'pry-byebug'

# always roll north
def roll(grid)
  inital = grid.flat_map.with_index { |r, r_i| r.each_index.select { |c_i| r[c_i] == 'O'}.map { |c_i| [r_i, c_i] } }
  final = []

  while current = inital.shift
    r, c = current
    tilted = [r - 1, c]

    if r - 1 < 0
      final << current
    elsif grid[tilted[0]][tilted[1]] == '#'
      final << current
    elsif final.include? tilted
      final << current
    else
      inital.unshift(tilted)
    end
  end

  0.upto(grid.size - 1).map do |r_i|
    0.upto(grid.size - 1).map do |c_i|
      if final.include? [r_i, c_i]
        'O'
      elsif grid[r_i][c_i] == '#'
        '#'
      else
        '.'
      end
    end
  end
end

def cycle(grid)
  1.upto(4).each do |i|
    if i == 1
      grid = roll(grid)
    else
      grid = roll(grid.transpose.map(&:reverse))
    end
  end

  grid.transpose.map(&:reverse)
end

grid = File.readlines('puzzle.input', chomp: true).map { |line| line.split('') }.freeze

CACHE = {}
i = 0
can_skip = true

while i < 1_000_000_000
  grid = cycle(grid)
  i += 1

  puts i

  if CACHE.has_key?(grid.hash) && can_skip
    delta = i - CACHE[grid.hash]
    jump = (1_000_000_000 - i) / delta
    i += jump * delta
    can_skip = false
  else
    CACHE[grid.hash] = i
  end
end

final_r = grid.flat_map.with_index { |r, r_i| r.each_index.select { |c_i| r[c_i] == 'O'}.map { |c_i| [r_i, c_i] } }
puts final_r.inject(0) { |acc, el| acc + (grid.size - el[0]) }
