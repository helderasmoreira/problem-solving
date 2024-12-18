require 'pry-byebug'

SIZE = 71
N_BYTES = 1024

directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
bytes = File.readlines('puzzle.input', chomp: true).map { |line| line.split(',').map(&:to_i) }.take(N_BYTES).to_set

queue = [[0, 0, 0]]
visited = Set.new

while !queue.empty?
  ci, ri, cost = queue.shift

  next if visited.include? [ri, ci]
  visited << [ri, ci]

  if ri == SIZE - 1 && ci == SIZE - 1
    puts cost
    break
  end

  directions.each do |dri, dci|
    nri = ri + dri
    nci = ci + dci

    next if nri < 0 || nri >= SIZE || nci < 0 || nci >= SIZE
    next if bytes.include? [nci, nri]

    queue << [nci, nri, cost + 1]
  end
end
