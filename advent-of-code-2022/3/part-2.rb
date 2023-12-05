class String
  def intersection(other, another)
    (self.chars & other.chars) & another.chars
  end
end

input = File.readlines('puzzle.input', chomp: true)

grouped = input.each_slice(3).to_a
grouped.map! { |group| group[0].intersection(group[1], group[2]) }.flatten!

priorities = ('a'..'z').to_a.concat(('A'..'Z').to_a)
sum = grouped.map { |priority| priorities.index(priority) + 1 }.sum

puts sum
