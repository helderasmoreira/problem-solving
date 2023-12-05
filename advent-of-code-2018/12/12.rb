Rule = Struct.new(:in, :out)

input = File.readlines('12.input', chomp: true)

TIMES = 20

state = input.first.scan(/initial state: (.*)/).flatten.first.strip.split('')
RULES = input.drop(2).map { |rule| Rule.new(*rule.split(' => ').map(&:strip)) }

expanded_left_by = 0
TIMES.times do |generation|
  indexes = []

  new_state =
    (Array.new(4, '.') + state + Array.new(4, '.')).each_cons(5).map do |pots|
      rule = RULES.find { |rule| rule.in == pots.join }
      rule&.out || '.'
    end

  expanded_left_by += 2
  state = new_state
end

indexes = []
state.each_with_index { |e, i| indexes << (i - expanded_left_by) if e == '#' }
puts "#{TIMES}: #{indexes.reduce(:+)}"

####### 2nd part #######

 p (50_000_000_000 - TIMES) * 58 + indexes.reduce(:+)
