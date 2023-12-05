require 'set'

numbers = File.readlines('puzzle.input', chomp: true).each_with_index.map do |line, row|
  number = line.reverse.chars.each_with_index.inject(0) do |acc, (el, ind)|
    element =
      case el
      when '-'
        -1
      when '='
        -2
      else
        el.to_i
      end

    acc += element * (5 ** ind)
  end

  number
end

target = numbers.sum
snafu = ''

while target.positive?
  case target % 5
  when 0
    snafu << '0'
    target = target / 5
  when 1
    snafu << '1'
    target = target / 5
  when 2
    snafu << '2'
    target = target / 5
  when 3
    snafu << '='
    target = target / 5 + 1
  when 4
    snafu << '-'
    target = target / 5 + 1
  end
end

puts snafu.reverse
