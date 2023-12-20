require 'pry-byebug'

Conjunction = Struct.new(:name, :raw_dest, :dest, :memory)
FlipFlop = Struct.new(:name, :raw_dest, :dest, :state)
Broadcaster = Struct.new(:raw_dest, :dest)

@broadcaster = nil
@modules = []
@pulses = []

File.readlines('puzzle.input', chomp: true).filter_map do |line|
  name, dest = line.split(' -> ')
  dest = dest.split(', ')

  if name.start_with? '%'
    @modules << FlipFlop.new(name[1..], dest, [], false)
  elsif name.start_with? '&'
    @modules << Conjunction.new(name[1..], dest, [], {})
  else
    @broadcaster = Broadcaster.new(dest)
  end
end

@broadcaster.dest = @broadcaster.raw_dest.map { |d| @modules.find { |m| m.name == d } }
@modules.each do |m1|
  m1.dest = m1.raw_dest.filter_map do |dest|
    @modules.find { |m2| m2.name == dest }.tap do |m2|
      if m2.is_a? Conjunction
        m2.memory[m1.name] = false
      end
    end
  end
end

def push
  @broadcaster.dest.each { |dest| @pulses << [@broadcaster, dest, false] }

  while current = @pulses.shift
    from, to, high = current

    @key_node.memory.each do |key, value|
      next unless value

      @to_watch[key] ||= @i
    end

    case to
    when FlipFlop
      next if high

      to.state = !to.state
      to.dest.each do |dest|
        @pulses << [to, dest, to.state]
      end
    when Conjunction
      to.memory[from.name] = high

      dest_high = to.memory.values.any? { |v| !v }
      to.dest.each do |dest|
        @pulses << [to, dest, dest_high]
      end
    when nil
      # node is not defined but pulse was registered and processed
    end
  end
end

# This only works if the input is carefully crafted — as these are...
# `rx` is behind a conjunction `ns`
# `ns` is behind four other conjunctions
# So we're looking for the first time each of these four receives a high pulse
# And so that `ns` would then send a low pulse to `rx`
# Hacky, I know :shrug:

@key_node = @modules.find { |x| x.raw_dest == ['rx'] }
@to_watch = @key_node.memory.clone.transform_values { nil }

@i = 0
while true do
  @i += 1
  push
  break if @to_watch.values.all? { |v| v }
end

puts @to_watch.values.reduce(:lcm)
