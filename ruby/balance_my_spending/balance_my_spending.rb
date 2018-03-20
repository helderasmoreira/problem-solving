require 'benchmark'

class BalanceMySpending
  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        while !input.eof? do
          input.readline #trash one line
          output << "#{way_more_smart(input.readline.split(' ').map{ |x| x.to_i }).join(',')}\n"
        end
      end
    end
  end

  def not_so_smart(values)
    positions = []
    before = [0]

    values.each_index do |i|
      before[i + 1] = before[i] + values[i]
      after = values[i + 1..-1].reduce(:+)
      positions << i if before[i] == after
    end

    positions
  end

  def way_more_smart(values)
    positions = []
    before = 0
    after = values.reduce(:+)

    values.each_index do |i|
      before += values[i - 1] if i > 0
      after -= values[i]
      positions << i if before == after
    end

    positions
  end
end

problem = BalanceMySpending.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('small.in') }
end
