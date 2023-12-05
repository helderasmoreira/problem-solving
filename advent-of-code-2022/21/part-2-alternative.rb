require 'pry-byebug'

$input = File.readlines('puzzle.input', chomp: true).map { |line| line.split(': ') }.to_h

def eval_monkey(name, humn)
  results = {}
  $input.cycle.each do |k, v|
    return results[name] if results[name].is_a? Integer
    next if results.key? k

    if number = Integer(v) rescue nil
      results[k] = number
    else
      replaced = v.gsub(/\w{4}/) { |monkey| monkey == 'humn' ? humn : (results[monkey] || monkey) }
      replaced = eval(replaced) rescue nil
      results[k] = replaced if replaced
    end
  end
end

low = 0
high = 1e15

# left side does not depend on human
target = eval_monkey("pzqf", 0)

while true
  mid = ((low + high) / 2).to_i

  result = target - eval_monkey("bhft", mid)
  if result < 0
    low = mid
  elsif result == 0
    puts mid
    break
  else
    high = mid
  end
end
