require 'benchmark'

class ChargingChaos
  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          input.readline # consume first line
          outlets = input.readline.split
          devices = input.readline.split
          output << %Q{Case ##{test_case}: #{analyze(devices, outlets)}\n}
        end
      end
    end
  end

  def apply(switch, outlet)
    "%0#{switch.size}b" % (switch.to_i(2) ^ outlet.to_i(2))
  end

  def valid?(devices, outlets)
    devices.each do |device|
      outlets.delete(outlets.find { |outlet| outlet == device })
    end
    outlets.size == 0
  end

  def brute_force(devices, outlets)
    # generate all possible switch combinations based on bit length
    # and test until the first is found

    nr_bits = outlets.first.size

    (2**nr_bits).times do |i|
      switch = "%0#{nr_bits}b" % i
      new_outlets = outlets.map { |outlet| apply(switch, outlet) }
      return switch.count('1') if valid?(devices, new_outlets)
    end
    'NOT POSSIBLE'
  end

  def not_brute_force(devices, outlets)
    # generate all possible switch combinations for the first device across all the outlets
    # is any of these switch combinations valid for all the others?

    switches = []
    nr_bits = devices.first.size
    outlets.each do |outlet|
      switches << "%0#{nr_bits}b" % (devices.first.to_i(2) ^ outlet.to_i(2))
    end

    switches.sort.each do |switch|
      new_outlets = outlets.map { |outlet| apply(switch, outlet) }
      result = valid?(devices, new_outlets)
      return switch.count('1') if result
    end
    'NOT POSSIBLE'
  end

  def analyze(devices, outlets)
    not_brute_force(devices, outlets)
  end
end

problem = ChargingChaos.new
Benchmark.bm do |x|
  x.report('test') { problem.solve('test.in') }
  x.report('small') { problem.solve('A-small-practice.in') }
  x.report('large') { problem.solve('A-large-practice.in') }
end
