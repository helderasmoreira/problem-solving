input = File.readlines('puzzle.input', chomp: true)

numbers = input.first.split(',').map(&:to_i)
boards = input[2..].map { |n| n.split.map(&:to_i) }.reject(&:empty?).each_slice(5).to_a

def winning_board?(board)
  board.any? { |row| row.compact.empty? } || board.transpose.any? { |row| row.compact.empty? }
end

winner = nil
winning_number = nil
n_losers = 5

numbers.each do |number|
  winning_number = number

  boards.map! do |board|
    board.map! do |row|
      row.map! { |b_number| b_number == number ? nil : b_number }
    end
  end

  loser_boards = boards.reject { |board| winning_board?(board) }

  if n_losers == 2 && loser_boards.size == 1
    winner = loser_boards.first
  else
    n_losers = loser_boards.size
  end

  break if n_losers == 0
end

puts winner.flatten.compact.sum * winning_number
