current_value = nil
increased = 0

File.readlines('puzzle.input', chomp: true).each do |line|
  line_i = line.to_i

  if !current_value.nil? && line_i > current_value
    increased += 1
  end

  current_value = line_i
end

puts increased
