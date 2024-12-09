require 'pry-byebug'

disk_map = File.readlines('puzzle.input', chomp: true).map { |line| line.split('') }.first

index = 0
expanded_map = []

disk_map.each_slice(2) do |file, space|
  expanded_map << [index] * file.to_i
  expanded_map << ['.'] * space.to_i
  index += 1
end

expanded_map.flatten!

expanded_map.each_with_index do |el, ind|
  if el == '.'
    last_n = expanded_map.rindex { |x| x != '.' }
    break if last_n < ind

    expanded_map[ind] = expanded_map[last_n]
    expanded_map[last_n] = '.'
  end
end

checksum =
  expanded_map.each_with_index.inject(0) do |acc, (el, ind)|
    if el == '.'
      acc
    else
      acc + (el.to_i * ind)
    end
  end

puts checksum
