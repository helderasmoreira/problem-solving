machines = []

File.readlines('puzzle.input', chomp: true).each do |line|
  lights = line.scan(/[.#]/).map { |light| light == '.' ? false : true }
  buttons = line.scan(/\(.*?\)/).map { |button| button.scan(/\d+/).map(&:to_i) }

  machines << { target: lights, buttons: buttons }
end

winners = []
machines.each do |machine|
  combinations = (0..1).to_a.repeated_permutation(machine[:buttons].size)

  machine_winners = combinations.select do |combination|
    current = [false] * machine[:target].size

    combination.each_with_index do |press, index|
      next if press.zero?

      machine[:buttons][index].each do |button|
        current[button] = !current[button]
      end
    end

    current == machine[:target]
  end

  winners << machine_winners.min_by { |winner| winner.sum }
end

puts winners.flatten.sum
