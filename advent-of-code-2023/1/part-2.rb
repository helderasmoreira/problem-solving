total = 0

STRINGS_TO_NUMBERS = {
  'one' => 1,
  'two' => 2,
  'three' => 3,
  'four' => 4,
  'five' => 5,
  'six' => 6,
  'seven' => 7,
  'eight' => 8,
  'nine' => 9
}

File.readlines('puzzle.input', chomp: true).each do |line|
  scanned = line.scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/).flatten

  first_value = STRINGS_TO_NUMBERS.fetch(scanned.first, scanned.first)
  second_value = STRINGS_TO_NUMBERS.fetch(scanned.last, scanned.last)

  total += "#{first_value}#{second_value}".to_i
end

puts total
