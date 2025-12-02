def invalid?(number)
  number.to_s.match?(%r{^(.+)(?:\1)+$})
end

sum = 0

File.readlines('puzzle.input', chomp: true).each do |line|
  ranges = line.split(',').map { |range| range.split('-').map(&:to_i) }

  ranges.each do |l, r|
    (l..r).each do |i|
      sum += i if invalid?(i)
    end
  end
end

puts sum
