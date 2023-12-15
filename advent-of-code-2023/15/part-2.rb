require 'pry-byebug'

def hash(string)
  string.each_byte.inject(0) { |acc, char| ((acc + char) * 17) % 256 }
end

boxes = {}

line = File.readlines('puzzle.input', chomp: true).first
line.split(',').each do |lens|
  label, op, fl = lens.scan(/(\w+)([=-])(\d*)/).flatten
  box_i = hash(label)

  boxes[box_i] ||= []
  lens_i = boxes[box_i].find_index { |e_label, _| e_label == label }

  case op
  when '='
    lens = [label, fl]
    if lens_i
      boxes[box_i][lens_i] = lens
    else
      boxes[box_i] << lens
    end
  when '-'
    boxes[box_i].delete_at(lens_i) if lens_i
  end
end

result = boxes.inject(0) do |acc, (key, value)|
  sum = 0
  value.each_with_index do |(_, fl), i|
    sum += (key + 1) * (i + 1) * fl.to_i
  end

  acc + sum
end

puts result
