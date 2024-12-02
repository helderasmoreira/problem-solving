current_value = nil
increased = 0

left = []
right = Hash.new(0)

File.readlines('puzzle.input', chomp: true).each do |line|
  l, r = line.split(' ').map(&:to_i)
  left << l
  right[r] ||= 0
  right[r] += 1
end

similarity = 0
left.each do |l|
  similarity += l * right[l]
end

puts similarity
