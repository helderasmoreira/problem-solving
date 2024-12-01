require 'pry-byebug'

input = File.readlines('puzzle.input', chomp: true).map { |line| line.split(' | ').map { |t| t.split(' ') } }

# 1, 7, 4, 8
n_signals = [2, 3, 4, 7]

values = {}

input.map! do |line|
  values[1] = line.flatten.find { |n| n.size == 2 }.chars.sort
  values[7] = line.flatten.find { |n| n.size == 3 }.chars.sort
  values[4] = line.flatten.find { |n| n.size == 4 }.chars.sort
  values[8] = line.flatten.find { |n| n.size == 7 }.chars.sort

  fourdiff = values[4] - values[1]

  # with 6
  # 0, 6, 9
  size_6 = line.flatten.select { |n| n.size == 6 }
  size_6.each do |n|
    if (values[4] - n.chars).empty?
      values[9] = n.chars.sort
    elsif (fourdiff - n.chars).empty?
      values[6] = n.chars.sort
    else
      values [0] = n.chars.sort
    end
  end

  # with 5
  # 2, 3, 5
  size_5 = line.flatten.select { |n| n.size == 5 }
  size_5.each do |n|
    if (values[1] - n.chars).empty?
      values[3] = n.chars.sort
    elsif (fourdiff - n.chars).empty?
      values[5] = n.chars.sort
    else
      values[2] = n.chars.sort
    end
  end

  x = line.last.map do |n|
    values.select { |k, v| v == n.chars.sort }
  end

  x.map(&:keys).flatten.join.to_i
end

puts input.sum
