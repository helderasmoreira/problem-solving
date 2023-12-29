require 'pry-byebug'

raw_connections = []
File.readlines('puzzle.input', chomp: true).map do |line|
  l, r = line.split(': ')
  r.split(' ').each { |c| raw_connections << [l, c] }
end

attempts = 0
while true do
  attempts += 1
  connections = raw_connections.map(&:clone)

  while connections.flatten.uniq.size > 2
    to_contract = connections.shuffle.shift
    n1, n2 = to_contract
    n3_key = "#{n1}-#{n2}"

    connections.delete(to_contract)
    connections.map! do |connection|
      if connection.include?(n1) || connection.include?(n2)
        connection.delete(n1)
        connection.delete(n2)
        connection << n3_key
      else
        connection
      end
    end
  end

  puts "attempt #{attempts}: #{connections.size}"
  break if connections.size == 3
end

puts connections.first.first.split('-').size * connections.first.last.split('-').size
