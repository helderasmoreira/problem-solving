require 'pry-byebug'

input = File.readlines('puzzle.input', chomp: true)

@a = input[0].match(/Register A: (\d+)/)[1].to_i
@b = input[1].match(/Register B: (\d+)/)[1].to_i
@c = input[2].match(/Register C: (\d+)/)[1].to_i

def combo(value)
  case value
  when 0, 1, 2, 3
    value
  when 4
    @a
  when 5
    @b
  when 6
    @c
  when 7
    raise 'oops'
  end
end

instructions = input[4].scan(/(\d+)/).flatten.map(&:to_i)
index = 0
output = []

while index < instructions.size
  opcode = instructions[index]
  operand = instructions[index + 1]

  case opcode
  when 0 # adv
    @a = (@a / (2 ** combo(operand))).to_i
  when 1 # bxl
    @b = @b ^ operand
  when 2 # bst
    @b = combo(operand) % 8
  when 3 # jnz
    if @a != 0
      index = operand
      next
    end
  when 4 # bxc
    @b = @b ^ @c
  when 5 # out
    output << combo(operand) % 8
  when 6 # bdv
    @b = (@a / (2 ** combo(operand))).to_i
  when 7 # cdv
    @c = (@a / (2 ** combo(operand))).to_i
  end

  index += 2
end

puts output.join(',')
