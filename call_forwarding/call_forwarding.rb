
require 'benchmark'
# http://pt.reddit.com/r/dailyprogrammer/comments/1g09qy/060913_challenge_127_intermediate_call_forwarding/
# does check for loops, could be better optimized on the stopping part though

class CallForwarding
  @@hasloop = false

  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        inputs = []
        1.upto(test_cases) do |_|
          line = input.readline.split(' ').map(&:to_i)
          inputs += [line]
        end
        day_to_test = input.readline.to_i
        analyze(inputs, day_to_test, output)
      end
    end
  end

  def analyze(inputs, day_to_test, output)
    nr_forwardings = 0
    inputs.each { |x| if day_to_test <= (x[2] + x[3]) then nr_forwardings += 1 end }
    output << "on day #{day_to_test} there are #{nr_forwardings} forwardings\n"

    best = 0
    0.upto(inputs.size - 1) do |i|
      chain = analyze_chain(inputs[i][0], inputs, inputs[i][0], output)
      best = chain if chain > best
    end

    if @@hasloop
      output << "found loop!\n"
    else
      output << "longest chain is #{best}\n"
    end
  end

  def analyze_chain(origin, inputs, true_origin, output)
    0.upto(inputs.size - 1) do |i|
      if inputs[i][0] == origin
        if inputs[i][1] == true_origin
          @@hasloop = true
          return 0
        else
          return analyze_chain(inputs[i][1], inputs, true_origin, output) + 1
        end
      end
    end
    0
  end
end

problem = CallForwarding.new
problem.solve('small-practice.in')
