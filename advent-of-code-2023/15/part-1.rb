require 'pry-byebug'

results = File.readlines('puzzle.input', chomp: true).map do |line|
  line.split(',').inject(0) do |acc, step|
    acc + step.each_byte.inject(0) { |acc, char| ((acc + char) * 17) % 256 }
  end
end

puts results
