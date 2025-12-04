grid = []
File.readlines('puzzle.input', chomp: true).each do |row|
  grid << row.split('')
end

accessible = 0
grid.each_with_index do |row, ri|
  row.each_with_index do |cell, ci|
    next if cell == '.'

    adjacent = 0
    [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].each do |dr, dc|
      nri = ri + dr
      nci = ci + dc

      next if nri < 0 || nri == grid.size
      next if nci < 0 || nci == row.size

      if grid[nri][nci] == '@'
        adjacent += 1
      end
    end

    if adjacent < 4
      accessible += 1
    end
  end
end

puts accessible
