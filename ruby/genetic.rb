require 'securerandom'

TARGET = 'Hello, world!'
POPULATION = 100
RATE = 10 # percentage

class Genetic
  def solve
    random_string = Array.new(TARGET.size) { random_char }.join('')

    i = 0
    while true do
      i += 1

      random_string, hamming_result = evolve(random_string)
      puts "Gen: #{i} | Fitness: #{hamming_result} | #{random_string} "

      break if hamming_result.zero?
      end
  end

  def random_char
    (32 + SecureRandom.random_number(95)).chr
  end

  def evolve(current)
    (1..POPULATION).map do |i|
      mutated = mutate(current)
      [mutated, hamming(mutated)]
    end.sort_by { |_, hamming| hamming }.first
  end

  def mutate(current)
    current.chars.map { |c| SecureRandom.random_number(100) < RATE ? random_char : c }.join('')
  end

  def hamming(current)
    result = 0
    current.chars.zip(TARGET.chars).each do |x, y|
      result += 1 if x != y
    end
    result
  end
end

Genetic.new.solve
