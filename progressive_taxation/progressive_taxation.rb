
require 'benchmark'
# https://www.reddit.com/r/dailyprogrammer/comments/cdieag/20190715_challenge_379_easy_progressive_taxation/
# income cap      marginal tax rate
#  ¤10,000           0.00 (0%)
#  ¤30,000           0.10 (10%)
# ¤100,000           0.25 (25%)
#    --              0.40 (40%)

class ProgressiveTaxation
  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i

        1.upto(test_cases) do |_|
          output << analyze(input.readline.to_i).to_i
          output << "\n"
        end
      end
    end
  end

  def analyze(value)
    if value < 10_000
      0
    elsif value < 30_000
      (value - 10_000) * 0.1
    elsif value < 100_000
      2_000 + (value - 30_000) * 0.25
    else
      2_000 + 17_500 + (value - 100_000) * 0.4
    end
  end
end

problem = ProgressiveTaxation.new
problem.solve('small-practice.in')
