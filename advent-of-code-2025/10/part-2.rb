require 'ruby-cbc'

machines = []

File.readlines('puzzle.input', chomp: true).each do |line|
  buttons = line.scan(/\(.*?\)/).map { |button| button.scan(/\d+/).map(&:to_i) }
  joltage = line.scan(/\{(.*)\}/).map { |match| match.first.split(',').map(&:to_i) }.first

  machines << { target: joltage, buttons: }
end

sum = 0
machines.each do |machine|
  equations = []

  machine[:target].each_with_index do |target, i|
    button_indices = machine[:buttons].each_index.select { |bt_idx| machine[:buttons][bt_idx].include?(i) }
    equations << [target, button_indices]
  end

  model = Cbc::Model.new
  variables = model.int_var_array(machine[:buttons].size, 0..Cbc::INF)

  model.minimize(variables.sum)
  equations.each do |target, button_indices|
    model.enforce(variables.values_at(*button_indices).sum == target)
  end

  problem = model.to_problem
  problem.solve

  sum += variables.map { |variable| problem.value_of(variable) }.sum
end

puts sum
