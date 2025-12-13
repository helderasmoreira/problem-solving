possible = 0
File.readlines('puzzle.input', chomp: true).each do |line|
  next if line.empty?
  next unless line.include?('x')

  size, presents = line.split(':').map(&:strip)
  area = size.split('x').map(&:to_i).reduce(:*)
  presents = presents.split(' ').map(&:to_i)

  possible += 1 if presents.sum * 9 <= area
end

puts possible
