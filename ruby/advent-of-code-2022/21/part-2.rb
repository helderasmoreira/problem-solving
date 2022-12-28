input = File.readlines('puzzle.input', chomp: true).map { |line| line.split(': ') }.to_h

equation = input["root"].gsub(' + ', ' = ')

while true do
  break if equation.count('a-z') == 1

  equation.gsub!(/\w{4}/) do |monkey|
    next 'x' if monkey == 'humn'

    value = Integer(input[monkey]) rescue input[monkey]
    if value.is_a? Integer
      input[monkey]
    else
      "(#{input[monkey]})"
    end
  end
end

# reducing it to make it easier for online equation solvers to handle it...
equation.gsub!(' ', '')
50.times { equation.gsub!(/\(\d+[+-\/*]\d+\)/) { |expression| eval(expression) } }

# now to use some way to solve the equation :-D
puts equation

