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
by_distance.take(1_000).each do |distance, a, b|
  a_in_circuit = circuits.find { |circuit| circuit.include?(a) }
  b_in_circuit = circuits.find { |circuit| circuit.include?(b) }

  if a_in_circuit && b_in_circuit
    if a_in_circuit != b_in_circuit
      b_in_circuit = circuits.delete(b_in_circuit)
      a_in_circuit.merge(b_in_circuit)
    else
      next
    end
  elsif a_in_circuit
    a_in_circuit.add(b)
  elsif b_in_circuit
    b_in_circuit.add(a)
  else
    circuits << Set[a, b]
  end
end

puts circuits.map(&:size).sort.reverse.take(3).inject(:*)
