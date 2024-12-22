require 'pry-byebug'

numbers = File.readlines('puzzle.input', chomp: true).map(&:to_i)

secret_numbers = []

numbers.each_with_index do |number, index|
  secret_numbers[index] = []
  secret_numbers[index] << [number.digits.first, nil]

  (1..2_000).each do |i|
    one = number * 64
    number = number ^ one
    number = number % 16777216

    two = (number / 32).to_i
    number = number ^ two
    number = number % 16777216

    three = number * 2048
    number = number ^ three
    number = number % 16777216

    secret_numbers[index] << [number.digits.first, number.digits.first - secret_numbers[index][i - 1][0]]
  end
end

cache = Hash.new(0)
secret_numbers.each do |buyer|
  index = 1
  seen = Set.new

  loop do
    break if index == buyer.size - 4

    a = buyer[index][1]
    b = buyer[index + 1][1]
    c = buyer[index + 2][1]
    d = buyer[index + 3][1]

    unless seen.include?([a, b, c, d])
      cache[[a, b, c, d]] += buyer[index + 3][0]
      seen.add([a, b, c, d])
    end

    index += 1
  end
end

max = cache.values.max
puts max
puts cache.key(max).inspect
