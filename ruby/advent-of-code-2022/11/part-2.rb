monkeys = []

File.readlines('puzzle.input', chomp: true).each do |line|
  if line.start_with? 'Monkey '
    monkeys << []
  else
    if line.lstrip.start_with? 'Starting items: '
      monkeys.last << line.lstrip.gsub('Starting items: ', '').split(', ').map(&:to_i)
    elsif line.lstrip.start_with? 'Operation: '
      operation = line.lstrip.gsub('Operation: new = old ', '')

      if operation.start_with? '* '
        value = operation.gsub('* ', '')

        if value == 'old' 
          monkeys.last << ->(x) { x * x }
        else 
          monkeys.last << ->(x) { x * value.to_i }
        end
      elsif operation.start_with? '+ '
        value = operation.gsub('+ ', '').to_i
        monkeys.last << ->(x) { x + value }
      end
    elsif line.lstrip.start_with? 'Test: '
      monkeys.last << line.lstrip.gsub('Test: divisible by ', '').to_i
    elsif line.lstrip.start_with? 'If true: '
      monkeys.last << [line.lstrip.gsub('If true: throw to monkey ', '').to_i]
    elsif line.lstrip.start_with? 'If false: '
      monkeys.last.last << line.lstrip.gsub('If false: throw to monkey ', '').to_i
    end
  end
end

lcm = monkeys.map { |monkey| monkey[2] }.reduce(:lcm)
times_inspected = Array.new(monkeys.size, 0)

10_000.times do 
  monkeys.each_with_index do |monkey, index|
    times_inspected[index] += monkey[0].size

    while item = monkey[0].shift
      reduced_item = item % lcm

      worry_level = monkey[1].call(item)
      adjusted_worry_level = worry_level % lcm

      if worry_level % monkey[2] == 0
        monkeys[monkey[3][0]][0] << adjusted_worry_level
      else
        monkeys[monkey[3][1]][0] << adjusted_worry_level
      end
    end
  end
end

puts times_inspected.max(2).inject(:*)
