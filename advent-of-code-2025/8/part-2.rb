def distance(a, b)
  Math.sqrt((a[0] - b[0])**2 + (a[1] - b[1])**2 + (a[2] - b[2])**2)
end

boxes = []
File.readlines('puzzle.input', chomp: true).each do |line|
  x, y, z = line.split(',').map(&:to_i)
  boxes << [x, y, z]
end

by_distance = boxes.combination(2).map { |a, b| [distance(a, b), a, b] }.sort_by { |distance, _, _| distance }

circuits = []
i = 0
while true do
  _, a, b = by_distance[i]
  a_in_circuit = circuits.find { |circuit| circuit.include?(a) }
  b_in_circuit = circuits.find { |circuit| circuit.include?(b) }

  if a_in_circuit && b_in_circuit
    if a_in_circuit != b_in_circuit
      b_in_circuit = circuits.delete(b_in_circuit)
      a_in_circuit.merge(b_in_circuit)
    end
  elsif a_in_circuit
    a_in_circuit.add(b)
  elsif b_in_circuit
    b_in_circuit.add(a)
  else
    circuits << Set[a, b]
  end

  i += 1
  break if circuits.size == 1 && circuits.first.size == boxes.size
end

puts by_distance[i][1][0] * by_distance[i][2][0]
