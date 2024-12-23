require 'pry-byebug'

connections = {}

File.readlines('puzzle.input', chomp: true).map do |line|
  one, two = line.split('-')

  connections[one] ||= []
  connections[one] << two

  connections[two] ||= []
  connections[two] << one
end

three_loop = Set.new
connections.keys.each do |key|
  queue = [[key, 1, [key]]]

  until queue.empty?
    k, s, path = queue.shift

    if s == 4
      if path[0] == path[3]
        three_loop << path.take(3).sort
      end

      next
    end

    connections[k].each do |v|
      next if v == k

      queue << [v, s + 1, path.dup << v]
    end
  end
end

puts three_loop.select { |a, b, c| "#{a[0]}#{b[0]}#{c[0]}".include?('t') }.size
