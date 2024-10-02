input = File.readlines('puzzle.input', chomp: true).map(&:to_i)

previous = 0
increased = -1
current_sum = 0
window_size = 3

i = 0
while i < input.length do
  current_sum += input[i]

  if i >= window_size-1
    increased += 1 if current_sum > previous

    previous = current_sum
    current_sum -= input[i - (window_size-1)]
  end

  i += 1
end

puts increased
