ranges = []
ids = []

File.readlines('puzzle.input', chomp: true).each do |line|
  next if line == ''

  if line.include?('-')
    a, b = line.split('-').map(&:to_i)
    ranges << (a..b)
  else
    ids << line.to_i
  end
end

puts ids.count { |id| ranges.any? { |range| range.include?(id) } }
