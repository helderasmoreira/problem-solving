input = File.readlines('8.input', chomp: true).map { |x| x.split.map(&:to_i) }.flatten

def process_metadata(input)
  n_children, n_metadata = input.shift(2)
  n_children.times.map { |_| process_metadata(input) } + input.shift(n_metadata)
end

# decided to try and use the output from the metadata processing as input
# instead of modifying the process_metadata for part 2
def process_value(input)
  return input.reduce(:+) unless input.any? { |x| x.is_a? Array }

  input.reverse.take_while { |x| !x.is_a? Array }.map do |x|
    desired_node = input[x - 1]
    if desired_node.is_a? Array
      process_value(input[x - 1])
    else
      0
    end
  end
end

p process_value(process_metadata(input.dup)).flatten.reduce(:+)

