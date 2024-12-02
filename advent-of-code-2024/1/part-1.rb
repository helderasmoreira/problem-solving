current_value = nil
increased = 0

left = []
right = []

File.readlines('puzzle.input', chomp: true).each do |line|
  l, r = line.split(' ').map(&:to_i)
  left << l
  right << r
end

left = left.sort
right = right.sort

diff = 0
left.zip(right).each do |pair|
  diff += pair.max - pair.min
end

puts diff
