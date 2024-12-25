require 'pry-byebug'

keys = []
locks = []

input = File.readlines('puzzle.input', chomp: true)
input.each_slice(8).each do |slice|
  row = slice.take(7).map { |line| line.split('') }
  row[0][0] == '#' ? locks << row : keys << row
end

total = 0
keys.each do |key|
  tkey = key.transpose

  locks.each do |lock|
    tlock = lock.transpose

    fit = true
    tlock.each_with_index do |row, ri|
      if row.count('#') + tkey[ri].count('#') > 7
        fit = false
        break
      end
    end

    total += 1 if fit
  end
end

puts total
