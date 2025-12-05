ranges = []

File.readlines('puzzle.input', chomp: true).each do |line|
  next if line == ''
  next if !line.include?('-')

  a, b = line.split('-').map(&:to_i)
  ranges << (a..b)
end

ranges.sort_by!(&:min)

i = 0
while i < ranges.size
  first = ranges[i]
  break if i + 1 == ranges.size

  second = ranges[i + 1]

  if first.overlap?(second)
    ranges[i] = [first.min, second.min].min..[first.max, second.max].max
    ranges.delete_at(i + 1)
  else
    i += 1
  end
end

puts ranges.map(&:size).sum
