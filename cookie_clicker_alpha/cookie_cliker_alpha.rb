require 'benchmark'

class CookieClickerAlpha
  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          line = input.readline.split.map(&:to_f)
          result = analyze(line[0], line[1], line[2])
          output << %Q{Case ##{test_case}: #{result}\n}
        end
      end
    end
  end

  def analyze_aux(current_time, cookies_per_second, cost, farm, goal)
    time_to_next_farm = cost / cookies_per_second
    time_to_goal = goal / cookies_per_second
    time_to_goal_after_next_farm = goal / (cookies_per_second + farm)
    if time_to_goal > (time_to_next_farm + time_to_goal_after_next_farm)
      analyze_aux(
        current_time + time_to_next_farm,
        cookies_per_second + farm,
        cost,
        farm,
        goal
      )
    else
      (current_time + time_to_goal).round(7)
    end
  end

  def analyze(cost, farm, x)
    cookies_per_second = 2.0
    analyze_aux(
      0.0,
      cookies_per_second,
      cost,
      farm,
      x
    )
  end
end

# still some problems in the large dataset
problem = CookieClickerAlpha.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('B-small-practice.in') }
  #x.report('large') { problem.solve('B-large-practice.in') }
end
