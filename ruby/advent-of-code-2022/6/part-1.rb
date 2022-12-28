input = File.readlines('puzzle.input', chomp: true)

SIZE = 4

input.each do |line|
  marker = []
  position = 0

  line.chars.each_with_index do |char, index|
    if marker.size == SIZE && marker.uniq.size == SIZE
      position = index
      break
    end

    marker << char
    marker.shift if marker.size > SIZE
  end

  puts position
end
