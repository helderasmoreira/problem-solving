require 'pry-byebug'

SIZE = 71

n_bytes = 1024
directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
all_bytes = File.readlines('puzzle.input', chomp: true).map { |line| line.split(',').map(&:to_i) }.to_set

loop do
  step = (all_bytes.size - n_bytes) / 2
  bytes = all_bytes.take(n_bytes + step)
  queue = [[0, 0, 0]]
  visited = Set.new

  success = false

  if step == 0
    puts "#{all_bytes[n_bytes]}"
    break
  end

  while !queue.empty?
    ci, ri, cost = queue.shift

    next if visited.include? [ri, ci]
    visited << [ri, ci]

    if ri == SIZE - 1 && ci == SIZE - 1
      success = true
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

  if !success
    all_bytes = all_bytes.take(n_bytes + step)
  else
    n_bytes += step
  end
end
