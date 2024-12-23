require 'pry-byebug'

connections = {}

File.readlines('puzzle.input', chomp: true).map do |line|
  one, two = line.split('-')

  connections[one] ||= []
  connections[one] << two

  connections[two] ||= []
  connections[two] << one
end

result = []
visited = Set.new

connections.keys.each do |key|
  queue = [[key, 1, [key]]]

  until queue.empty?
    k, s, path = queue.shift

    next if visited.include? path.sort
    visited.add(path.sort)

    result = path if path.size > result.size

    connections[k].each do |v|
      next if v == k
      next if path.include? v

      next unless path.all? { |p| connections[v].include? p }

      queue << [v, s + 1, path.dup << v]
    end
  end
end

puts result.sort.join(',')
