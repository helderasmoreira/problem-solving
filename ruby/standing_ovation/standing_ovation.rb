require 'benchmark'

class StandingOvation
  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          line = input.readline.split
          data = line[1].split(//).map(&:to_i)
          output << %Q{Case ##{test_case}: #{analyze(data)}\n}
        end
      end
    end
  end

  def sum_until(array, index)
    array.take(index).reduce(:+) || 0
  end

  def analyze(data)
    total_people_needed = 0
    data.each_index do |shyness|
      # no one to get up
      next if data[shyness].zero?

      people_needed = (shyness - sum_until(data, shyness))
      if people_needed.positive?
        total_people_needed += people_needed
        data[shyness] += people_needed
      end
    end

    total_people_needed
  end
end

problem = StandingOvation.new
Benchmark.bm do |x|
  x.report('test') { problem.solve('test.in') }
  x.report('small') { problem.solve('A-small-practice.in') }
  x.report('large') { problem.solve('A-large-practice.in') }
end
