input = File.readlines('puzzle.input', chomp: true)

numbers = input.first.split(',').map(&:to_i)
boards = input[2..].map { |n| n.split.map(&:to_i) }.reject(&:empty?).each_slice(5).to_a

def winning_board?(board)
  board.any? { |row| row.compact.empty? } || board.transpose.any? { |row| row.compact.empty? }
end

winner = nil
winning_number = nil

numbers.each do |number|
  winning_number = number

  boards.map! do |board|
    board.map! do |row|
      row.map! { |b_number| b_number == number ? nil : b_number }
    end

    winner = board if winning_board?(board)
    break if winner

    board
  end

  break if winner
end

puts winner.flatten.compact.sum * winning_number
