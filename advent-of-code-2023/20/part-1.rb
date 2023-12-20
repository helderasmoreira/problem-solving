require 'pry-byebug'

Conjunction = Struct.new(:name, :raw_dest, :dest, :memory)
FlipFlop = Struct.new(:name, :raw_dest, :dest, :state)
Broadcaster = Struct.new(:raw_dest, :dest)

@broadcaster = nil
@modules = []
@pulses_values = []
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
  m1.dest = m1.raw_dest.map do |dest|
    @modules.find { |m2| m2.name == dest }.tap do |m2|
      if m2.is_a? Conjunction
        m2.memory[m1.name] = false
      end
    end
  end
end

def push
  (@broadcaster.dest.size + 1).times { @pulses_values << false }
  @broadcaster.dest.each { |dest| @pulses << [@broadcaster, dest, false] }

  while current = @pulses.shift
    from, to, high = current

    case to
    when FlipFlop
      next if high

      to.state = !to.state
      to.dest.each do |dest|
        @pulses << [to, dest, to.state]
        @pulses_values << to.state
      end
    when Conjunction
      to.memory[from.name] = high
      dest_high = to.memory.values.any? { |v| !v }
      to.dest.each do |dest|
        @pulses << [to, dest, dest_high]
        @pulses_values << dest_high
      end
    when nil
      # node is not defined in the list but pulse was registered and processed anyway
      # which for this part is all that matters
    end
  end
end

1000.times { push }

puts @pulses_values.partition { |pv| pv }.map(&:size).reduce(:*)
