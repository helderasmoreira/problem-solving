path = ['/']
directory_sizes = Hash.new(0)

File.readlines('puzzle.input', chomp: true).each_with_index do |line, index|
  next if index == 0
  tokens = line.split(' ')

  if tokens[0] == '$' && tokens[1] == 'cd'
    if tokens.last == '..'
      path.pop
    else
      path << "#{path.last}#{tokens.last}/"
    end
  elsif tokens[0] != 'dir'
    path.each { |element| directory_sizes[element] += tokens[0].to_i }
  end
end

space_needed = 30_000_000 - (70_000_000 - directory_sizes['/'])
puts directory_sizes.values.select { |size| size > space_needed }.min
