paths = {}

File.readlines('puzzle.input', chomp: true).each do |line|
  from, to = line.split(':').map(&:strip)
  paths[from] ||= []
  to.split(' ').each { |path| paths[from] << path }
end

queue = ['you']

possible = 0
until queue.empty?
  current = queue.shift

  if current == 'out'
    possible += 1
    next
  end

  queue.concat(paths[current])
end

puts possible
