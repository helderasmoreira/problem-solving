require 'benchmark'

class StacksOfBoxes
  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        until input.eof? do
          n, boxes = input.readline.split(' ')
          boxes = boxes.chars.map(&:to_i)
          total = boxes.reduce(:+)
          n = n.to_i

          res =
            if (total % n).zero?
              not_so_smart(n, total / n, boxes)
            else
              []
            end

          output << "#{res.map(&:join).join("\n")}\n\n"
        end
      end
    end
  end

  def not_so_smart(n, value, boxes, packed_boxes=Array.new(n) { [] })
    if boxes.empty?
      packed_boxes
    else
      packed_boxes.each_index do |i|
        new_packed_boxes = packed_boxes.map(&:dup)
        box = boxes[0]
        new_packed_boxes[i].push(box)

        solution = not_so_smart(n, value, boxes.drop(1), new_packed_boxes)

        if valid?(n, value, solution)
          return solution
        end
      end
      []
    end
  end

  def valid?(n, value, packed_boxes)
    if packed_boxes.size != n
      false
    else
      packed_boxes.all? { |x| x.reduce(:+) == value }
    end
  end

  # TODO
  # tailrec?
  # iterative?
end

problem = StacksOfBoxes.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('small.in') }
end
