ADJUSTED_VALUES = { 'S' => 'a', 'E' => 'z' }
Node = Struct.new(:value, :row, :column, :explored, :count)

def adjusted_value(value)
  ADJUSTED_VALUES[value] || value
end

def unexplored_edges_for(map, current)
  edges = [
    map.dig(current.row - 1, current.column),
    map.dig(current.row + 1, current.column),
    map.dig(current.row, current.column - 1),
    map.dig(current.row, current.column + 1)
  ]

  edges.compact.select do |node|
    !node.explored &&
    (adjusted_value(node.value).ord - adjusted_value(current.value).ord) <= 1
  end
end

root = nil
map = File.readlines('puzzle.input', chomp: true).map.with_index do |line, row|
  line.split('').map.with_index do |value, column|
    Node.new(value, row, column, false, 1).tap { |node| root = node if node.value == 'S' }
  end
end

root.explored = true
queue = []
queue << root

while current = queue.shift do
  if current.value == 'E'
    puts current
  else
    unexplored_edges_for(map, current).each do |node|
      node.explored = true
      node.count += current.count

      queue << node
    end
  end
end
