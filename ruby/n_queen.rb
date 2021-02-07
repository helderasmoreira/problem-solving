require 'benchmark'

def n_queen(n)
  board = Array.new(n) { |x| Array.new(n) { '.' } }
  queens = Array.new(n) { 'o' }
  solve(board, queens)
end

def solve(board, queens)
  if queens.size == 0
    board
  else
    board.each_index do |i|
      board[i].each_index do |z|
        next if !is_valid?(board, i, z)

        board[i][z] = 'o'
        return board if solve(board, queens.drop(1))
        board[i][z] = '.'
      end
    end
    return nil
  end
  board
end

# is position i,z in check by
# any queen in row i
# any queen in column z
# any queen in diagonal i-1, z+1
# any queen in diagonal i+1, z-1
# any queen in diagonal i-1, z-1
# any queen in diagonal i+1, z+1
def is_valid?(board, i ,z)
  board[i][z] != 'o' &&
  left_up(board, i, z) &&
  right_down(board, i, z) &&
  left_down(board, i, z) &&
  right_up(board, i, z) &&
  board[i].none? { |x| x == 'o' } &&
  !board.map { |x| x[z] }.any? { |x| x == 'o' }
end

def left_up(board, i, z)
  i < 0 ? true : board[i][z] != 'o' && left_up(board, i-1, z-1)
end

def right_down(board, i, z)
  i > (board.size - 1) ? true : board[i][z] != 'o' && right_down(board, i+1, z+1)
end

def left_down(board, i, z)
  i > (board.size - 1) ? true : board[i][z] != 'o' && left_down(board, i+1, z-1)
end

def right_up(board, i, z)
  i < 0 ? true : board[i][z] != 'o' && right_up(board, i-1, z+1)
end

def print_board(board)
  board.each do |line|
    p line
  end
end

solution = nil
Benchmark.bm do |x|
  x.report('n_queen') { solution = n_queen(10) }
end

if solution
  print_board(solution)
else
  p ':('
end
