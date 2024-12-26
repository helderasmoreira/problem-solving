require 'pry-byebug'

@directions = { up: [-1, 0], down: [1, 0], left: [0, -1], right: [0, 1] }

@directional = {
  up: [0, 1],
  down: [1, 1],
  left: [1, 0],
  right: [1, 2],
  A: [0, 2]
}
numeric = {
  '1' => [2, 0],
  '2' => [2, 1],
  '3' => [2, 2],
  '4' => [1, 0],
  '5' => [1, 1],
  '6' => [1, 2],
  '7' => [0, 0],
  '8' => [0, 1],
  '9' => [0, 2],
  '0' => [3, 1],
  'A' => [3, 2]
}

codes = File.readlines('puzzle.input', chomp: true).map { |line| line.split('') }

def manhattan_distance(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

def find_best_paths(start, goal, pad)
  queue = [[start, []]]

  until queue.empty?
    current, path = queue.shift
    ri, ci = current

    if current == goal
      yield path
      next
    end

    d2target = manhattan_distance(current, goal)

    @directions.each do |dname, (dri, dci)|
      nri = ri + dri
      nci = ci + dci

      next unless pad.values.include?([nri, nci])
      next if manhattan_distance([nri, nci], goal) > d2target

      queue << [[nri, nci], path.dup << dname]
    end
  end
end

def robot(commands, level=1)
  current = [0, 2]

  return commands.size if level == 3

  min_all_commands = 0
  commands.each do |command|
    goal = @directional[command]

    min_command = nil
    find_best_paths(current, goal, @directional) do |dcommand|
      dcommand_size = robot(dcommand << :A, level + 1)
      min_command = dcommand_size if min_command.nil? || dcommand_size < min_command
    end

    current = goal
    min_all_commands += min_command
  end

  min_all_commands
end

total = 0

codes.each do |code|
  current = [3, 2]
  min_all_commands = 0
  code.each_with_index do |number, index|
    goal = numeric[number]

    min_number = nil
    find_best_paths(current, goal, numeric) do |command|
      command_size = robot(command << :A)
      min_number = command_size if min_number.nil? || command_size < min_number
    end

    current = goal
    min_all_commands += min_number
  end

  number = code.join('').scan(/^\d+/)[0].to_i
  total += min_all_commands * number
end

puts total
