input = File.readlines('1.input', chomp: true).map(&:to_i)

sum = input.reduce(:+)
p sum

####### 2nd part #######

seen = {}
sum = 0

input.cycle do |n|
  sum += n

  if seen[sum]
    puts sum
    break
  end

  seen[sum] = true
end
