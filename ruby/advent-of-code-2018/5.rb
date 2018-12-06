input = File.readlines('5.input', chomp: true)

def opposites(a, b)
  return false if a.nil? || b.nil?
 (a.ord - b.ord).abs == 32
end

def always_positive(x)
  x < 0 ? 0 : x
end

def react(x)
  i = 0
  loop do
    break if i >= x.size
    if opposites(x[i], x[i + 1])
      x.slice!(i)
      x.slice!(i)
      i = always_positive(i - 1)
    else
      i += 1
    end
  end
  x
end

def react_best(x)
  ('a'..'z').to_a.map do |c|
    [c, react(x.tr("\\^#{c}#{c.upcase}", '')).size]
  end.sort_by { |x| x.last }
end

p react(input[0].strip).size
p react_best(input[0].strip)

