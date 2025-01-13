require 'pry-byebug'

initial = {}
gates = []

File.readlines('puzzle.input', chomp: true).each do |line|
  next if line.empty?

  if line.include?(':')
    wire, value = line.split(': ')
    initial[wire] = value.to_i
  else
    left, operator, right, _, destination = line.split(' ')
    gates << [left, operator, right, destination]
  end
end

until gates.empty?
  gate = gates.shift
  left, operator, right, dest = gate

  left_value = initial[left]
  right_value = initial[right]

  if left_value.nil? || right_value.nil?
    gates << gate
    next
  end

  case operator
  when 'AND'
    initial[dest] = left_value & right_value
  when 'OR'
    initial[dest] = left_value | right_value
  when 'XOR'
    initial[dest] = left_value ^ right_value
  end
end

value = []
initial.sort.each { |k, v| k.include?('z') ? value << v : nil }
puts value.reverse.join('').to_i(2)
