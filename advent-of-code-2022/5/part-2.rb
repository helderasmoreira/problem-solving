input = File.readlines('puzzle.input')

crate_lines = []
moves = []

input.each do |line|
  if line.include?('[')
    crate_line = []
    line.chars.each_slice(4) do |slice|
      crate = slice.join.gsub(/[^A-Z]/, '')
      crate_line << (crate.empty? ? nil : crate)
    end

    crate_lines << crate_line
  elsif line.include?('move')
    moves << line.gsub(/\D/, ' ').split(' ').map(&:to_i)
  end
end

# just to make it easier to visualize
crate_lines = crate_lines.transpose.map { |column| column.compact }

moves.each_with_index do |move, index|
  elements = crate_lines[move[1] - 1].shift(move[0])
  crate_lines[move[2] - 1].unshift(*elements)
end

puts crate_lines.map { |column| column[0] }.join
