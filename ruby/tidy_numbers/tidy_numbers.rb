require 'benchmark'

class TidyNumbers
  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          output << %Q{Case ##{test_case}: #{smart(input.readline.to_i)}\n}
        end
      end
    end
  end

  def tidy?(n)
    yes = true
    n.to_s.split("").map(&:to_i).reduce {|acum, elem| break unless yes &= (elem >= acum); elem }
    yes
  end

  def brute_force(n)
    n.downto(0).find {|n| tidy?(n) }
  end

  # looking at number from right to left
  # if digit is smaller than next digit
  #  change that and all to the left to 9 and mark that we need to reduce the next one
  # if we need to reduce the next one and reducing one makes it below zero,
  #   make it a 9 and reduce the next one
  # otherwise reduce it by 1
  def smart(n)
    n = n.to_s.split("").map(&:to_i).reverse

    trail = false
    (0..n.size-2).each do |i|
      if n[i] < n[i+1]
        (0..i).each do |i|
          n[i] = 9
        end

        trail = true
      end

      if trail
        n[i+1] =
          if n[i+1]-1 >= 0
            trail = false
            n[i+1]-1
          else
            9
          end
      end
    end

    n.reverse.join("").to_i
  end
end

problem = TidyNumbers.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('B-small-practice.in') }
  x.report('large') { problem.solve('B-large-practice.in') }
end
