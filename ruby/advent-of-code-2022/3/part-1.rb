class String
  def intersection(other)
    self.chars & other.chars
  end
end

input = File.readlines('puzzle.input', chomp: true).map { |line|
  [line[0..(line.size / 2) - 1], line[-(line.size / 2)..]]
}

intersections = input.map { |rucksack| rucksack.first.intersection(rucksack.last) }.flatten
priorities = ('a'..'z').to_a.concat(('A'..'Z').to_a)

sum = intersections.map { |priority| priorities.index(priority) + 1 }.sum

puts sum
