require 'pry-byebug'

possible = []

File.readlines('puzzle.input', chomp: true).each do |line|
  total, rest = line.split(': ')
  rest = rest.split(' ').map(&:to_i)
  total = total.to_i

  i = 1
  options = [rest.first]
  loop do
    break if i == rest.size

    new_options = []

    options.each do |option|
      new_options << option + rest[i]
      new_options << option * rest[i]
    end

    options = new_options
    i += 1
  end

  possible << total if options.include? total
end

puts possible.sum
