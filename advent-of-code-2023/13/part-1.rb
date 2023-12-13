require 'pry-byebug'

patterns = []
patterns_i = 0

File.readlines('puzzle.input', chomp: true).each do |line|
  if line.empty?
    patterns_i += 1
  else
    patterns[patterns_i] ||= []
    patterns[patterns_i] << line.split('')
  end
end

def max_mirror(pattern)
  candidates = 0.upto(pattern.size - 1).select { |r_i| pattern[r_i] == pattern[r_i +1] }
  return 0 if candidates.empty?

  candidates.find do |c|
    max_delta = [c, (pattern.size - 1) - (c + 1)].min

    pattern[(c - max_delta)..c] == pattern[(c + 1)..(c + 1 + max_delta)].reverse
  end&.then { |c| c + 1 } || 0
end

result = patterns.inject(0) do |sum, pattern|
  sum + max_mirror(pattern) * 100 + max_mirror(pattern.transpose)
end

puts result
