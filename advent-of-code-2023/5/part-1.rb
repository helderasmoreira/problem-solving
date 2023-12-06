require 'pry-byebug'

Seed = Struct.new(:value, :seen)
Mapping = Struct.new(:destination, :source, :delta)

seeds = []

File.readlines('puzzle.input', chomp: true).each_with_index do |line, index|
  next if line.empty?

  if index == 0
    # initial parse of the seeds
    seeds = line.split(':').last.split.map { |value| Seed.new(value: value.to_i, seen: false) }
  elsif line.end_with?(':')
    # reset the state, changing section
    seeds.each { |seed| seed.seen = false }
  else
    mapping = line.split(' ').map(&:to_i).then { |destination, source, delta| Mapping.new(destination:, source:, delta:) }

    seeds.map! do |seed|
      next seed if seed.seen
      next seed unless (mapping.source...(mapping.source + mapping.delta)).cover?(seed.value)

      Seed.new(value: (seed.value - mapping.source) + mapping.destination, seen: true)
    end
  end
end

puts seeds.map(&:value).min
