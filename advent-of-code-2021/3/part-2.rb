input = File.readlines('puzzle.input', chomp: true).map { |n| n.split('') }

ogr = nil
0.upto(input.first.size).each do |n|
  source = ogr || input
  transposed = source.transpose

  zero = transposed[n].count('0')
  one = transposed[n].count('1')
  value = one >= zero ? '1' : '0'

  ogr = source.select { |i| i[n] == value }
  break if ogr.size == 1
end

co2sr = nil
0.upto(input.first.size).each do |n|
  source = co2sr || input
  transposed = source.transpose

  zero = transposed[n].count('0')
  one = transposed[n].count('1')
  value = zero <= one ? '0' : '1'

  co2sr = source.select { |i| i[n] == value }
  break if co2sr.size == 1
end

puts ogr.join.to_i(2)
puts co2sr.join.to_i(2)

puts ogr.join.to_i(2) * co2sr.join.to_i(2)
