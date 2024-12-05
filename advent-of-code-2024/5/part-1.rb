require 'pry-byebug'

rules = []
updates = []

File.readlines('puzzle.input', chomp: true).each do |line|
  if line.include? '|'
    rules << line.split('|').map(&:to_i)
  elsif line.include? ','
    updates << line.split(',').map(&:to_i)
  end
end

correct_updates =
  updates.select do |update|
    !update.combination(2).any? { |a, b| rules.include? [b, a] }
  end

puts correct_updates.map { |c| c[c.length / 2] }.sum
