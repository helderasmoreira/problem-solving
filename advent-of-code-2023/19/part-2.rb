require 'pry-byebug'

WORKFLOWS = {}

File.readlines('puzzle.input', chomp: true).map do |line|
  next if line.empty? || line.start_with?('{')

  name, rules = line.scan(/(\w+){(.*)}/).flatten
  WORKFLOWS[name] = rules.split(',').map { |rule| rule.split(':') }
end

def combinations(rules, ranges)
  current = rules[0]
  tail = rules[1..]

  return ranges.map(&:size).reduce(:*) if current == ['A']
  return 0 if current == ['R']
  return combinations(WORKFLOWS[current.first], ranges) if current.size == 1

  condition, destination = current
  left, op, right = condition.scan(/(\w+)([<>])(\d+)/).flatten
  right = right.to_i

  range_i = "xmas".index(left)
  case op
  when '<'
    range = ranges[range_i]
    true_ranges = ranges.dup.tap { |r| r[range_i] = (range.min...right) }
    false_ranges = ranges.dup.tap { |r| r[range_i] = (right..range.max) }

    combinations([[destination]], true_ranges) +
    combinations(tail, false_ranges)
  when '>'
    range = ranges[range_i]
    true_ranges = ranges.dup.tap { |r| r[range_i] = ((right + 1)..range.max) }
    false_ranges = ranges.dup.tap { |r| r[range_i] = (range.min..right) }

    combinations([[destination]], true_ranges) +
    combinations(tail, false_ranges)
  end
end

puts combinations(WORKFLOWS['in'], [(1..4000)] * 4)
