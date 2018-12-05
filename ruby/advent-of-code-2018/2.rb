input = File.readlines('2.input', chomp: true)

occurrences =
  input.map do |word|
    hash = Hash.new(0)
    word.each_char do |c|
      hash[c] += 1
    end
    hash
  end

twos = 0
threes = 0

occurrences.each do |o|
  twos += 1 if o.has_value?(2)
  threes += 1 if o.has_value?(3)
end

p twos * threes

####### 2nd part #######

# assuming both have the same size
def distance(a, b)
  a.chars.each.with_index.count { |char, index| char != b[index] }
end

winner =
  input.combination(2).to_a.select do |a|
    distance(a[0], a[1]) == 1
  end.flatten

result = ""
winner[0].each_char.with_index do |char, index|
  result += char if char == winner[1][index]
end
p result

