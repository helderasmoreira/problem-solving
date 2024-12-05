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

incorrect_indices = Set.new

ui = 0
while ui < updates.size
  correct = true
  update = updates[ui]

  update.each_with_index do |a, ai|
    update.each_with_index do |b, bi|
      next if bi <= ai

      if rules.include? [b, a]
        correct = false
        update[ai] = b
        update[bi] = a
        break
      end
    end

    break if !correct
  end

  if correct
    ui += 1
  else
    incorrect_indices << ui
  end
end

puts incorrect_indices.map { |i| updates[i] }.map { |u| u[u.length / 2] }.sum
