require 'pry-byebug'

Seed = Struct.new(:range, :seen)
Mapping = Struct.new(:destination, :source, :delta) do
  def range
    source...(source + delta)
  end

  def difference
    destination - source
  end
end

seeds = []

def intersection(one, other)
  return if one.max < other.begin || other.max < one.begin

  [one.begin, other.begin].max..[one.max, other.max].min
end

File.readlines('puzzle.input', chomp: true).each_with_index do |line, index|
  next if line.empty?

  if index == 0
    # initial parse of the seeds
    seeds = line.split(':').last.split.each_slice(2).map { |value, delta| Seed.new(range: value.to_i...(value.to_i + delta.to_i), seen: false) }
  elsif line.end_with?(':')
    # reset the state, changing section
    seeds.each { |seed| seed.seen = false }
  else
    mapping = line.split(' ').map(&:to_i).then { |destination, source, delta| Mapping.new(destination:, source:, delta:) }

    seeds.map! do |seed|
      next seed if seed.seen

      intersection = intersection(seed.range, mapping.range)
      next seed unless intersection

      left = Seed.new(range: seed.range.begin...intersection.begin - 1, seen: false)
      seeds << left if left.range.size > 0

      right = Seed.new(range: (intersection.end + 1)...seed.range.end, seen: false)
      seeds << right if right.range.size > 0

      new_begin = intersection.begin + mapping.difference
      new_end = intersection.end + 1 + mapping.difference
      Seed.new(range: new_begin...new_end, seen: true)
    end
  end
end

puts seeds.map { |seed| seed.range.begin }.min
