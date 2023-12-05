input = File.readlines('puzzle.input', chomp: true).map { |line| line.split(': ') }.to_h

results = {}
input.cycle.each do |k, v|
  break if results["root"].is_a? Integer
  next if results.key? k

  if number = Integer(v) rescue nil
    results[k] = number
  else
    replaced = v.gsub(/\w+/) { |monkey| results[monkey] || monkey }
    replaced = eval(replaced) rescue nil
    results[k] = replaced if replaced
  end
end

puts results["root"]
