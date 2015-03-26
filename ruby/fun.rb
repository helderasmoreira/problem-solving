# If we have a sentence like this:
# "In this sentence there are _ 0, _ 1, _ 2, _ 3, _ 4, _ 5, _ 6, _ 7, _ 8, _ 9."
# Write a problem to find the right combination of numbers that makes the sentence valid.


require 'benchmark'

s = '*0*1*2*3*4*5*6*7*8*9'

def transform_string(string)
  index = string.index('*')
  if index
    1.upto(9) do |i|
      new_string = string.sub('*', i.to_s)
      break unless still_possible?(new_string)
      if transform_string(new_string)
        p "winner: #{new_string}"
        return true
      end
    end
    false
  else
    valid?(string)
  end
end

def still_possible?(string)
  string.chars.each_slice(2) do |n, z|
    return false if n.to_i > ( string.count(z) + string.count('*'))
  end
  true
end

def valid?(string)
  string.chars.each_slice(2) do |n, z|
    return false if n.to_i != string.count(z)
  end
  true
end

time = Benchmark.realtime do
  transform_string(s)
end
puts "Time elapsed #{time*1000} milliseconds"
