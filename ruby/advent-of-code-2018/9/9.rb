def solve_naive(n_players, highest_marble)
  scores = Array.new(n_players, 0)
  current_marble = 0
  marbles = [current_marble]
  current_marble_index = 0
  player = 1

  (0..n_players - 1).cycle do |player|
    current_marble += 1
    break if current_marble > highest_marble

    if current_marble % 23 == 0
      current_marble_index = (current_marble_index - 7) % marbles.size

      scores[player] += marbles.delete_at(current_marble_index)
      scores[player] += current_marble
    else
      current_marble_index = (current_marble_index + 2) % marbles.size
      marbles.insert(current_marble_index, current_marble)
    end
  end
  scores.max
end

Marble = Struct.new(:value, :previous, :next) do
  def remove
    self.next.previous = self.previous
    self.previous.next = self.next
    self.next
  end

  def insert(value)
    new_node = Marble.new(value, self.next, self.next.next)
    self.next.next.previous = new_node
    self.next.next = new_node
    new_node
  end
end

# a nice reminder on how inefficient arrays are...
# damn, never thought it would make this much difference

def solve_smart(n_players, highest_marble)
  start = Marble.new(0)
  start.previous = start
  start.next = start

  scores = Array.new(n_players, 0)
  current = start
  marble = 0

  (0..n_players - 1).cycle do |player|
    marble += 1
    break if marble > highest_marble

    if marble % 23 == 0
      7.times { current = current.previous }
      scores[player] += current.value
      scores[player] += marble
      current = current.remove
    else
      current = current.insert(marble)
    end
  end
    scores.max
end

p solve_naive(448, 71628)
puts ''
p solve_smart(448, 71628)
p solve_smart(448, 71628 * 100)
