input =

calories_count = Hash.new(0)
index = 0

File.readlines('puzzle.input', chomp: true).each do |line|
  if line.empty?
    index += 1
  else
    calories_count[index] += line.to_i
  end
end

puts calories_count.values.max
