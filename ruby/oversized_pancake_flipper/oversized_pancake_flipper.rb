require 'benchmark'

class OversizedPancakeFlipper
  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          x, k = input.readline.split
          x = x.split("").map { |n| n == '+' }
          output << %Q{Case ##{test_case}: #{analyze(x, k.to_i)}\n}
        end
      end
    end
  end

  def happy(x)
    x.all? { |n| n == true }
  end

  def analyze(x, k)
    flips = 0
    (0..x.length-k).each do |n|
      unless x[n]
        (0..k-1).each do |i|
          x[n+i] = !x[n+i]
        end
        flips += 1
      end
    end

    if happy(x)
      flips
    else
      "IMPOSSIBLE"
    end
  end
end

problem = OversizedPancakeFlipper.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('A-small-practice.in') }
  x.report('large') { problem.solve('A-large-practice.in') }
end
