require 'json'

def compare_lists(one, another)
  return if one.empty? && another.empty?
  return true if one.empty?
  return false if another.empty?

  if one.size == 1 && another.size == 1 && one.first.is_a?(Integer) && another.first.is_a?(Integer)
    if one.first == another.first
      nil
    else
      one.first < another.first
    end
  else
    first = compare_lists(Array(one.first), Array(another.first))
    first.nil? ? compare_lists(one.drop(1), another.drop(1)) : first
  end
end

pairs = File.readlines('puzzle.input', chomp: true).each_slice(3).map do |first, second, _|
  compare_lists(JSON.parse(first), JSON.parse(second))
end

puts 1.upto(pairs.size).each.select { |index| pairs[index - 1] }.sum
