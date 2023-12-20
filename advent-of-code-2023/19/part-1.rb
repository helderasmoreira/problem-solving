require 'pry-byebug'

workflows = {}
parts = []

File.readlines('puzzle.input', chomp: true).map do |line|
  next if line.empty?

  if line.start_with? '{'
    parts << ['x', 'm', 'a', 's'].zip(
      line.scan(/{x=(\d+),m=(\d+),a=(\d+),s=(\d+)}/).flatten.map(&:to_i)
    ).to_h
  else
    name, rules = line.scan(/(\w+){(.*)}/).flatten
    workflows[name] = rules.split(',').map { |rule| rule.split(':') }
  end
end

status = {}
parts.each do |part|
  to_visit = ['in']

  while current = to_visit.pop
    workflows[current].each do |rule|
      if rule.size == 1
        case rule.first
        when 'A', 'R'
          status[part] = rule.first
        else
          to_visit << rule.first
        end
        break
      else
        condition, destination = rule
        if eval(condition.gsub(/[xmas]/, part))
          case destination
          when 'A', 'R'
            status[part] = rule.last
          else
            to_visit << rule.last
          end
          break
        end
      end
    end
  end
end

puts status.map { |p, s| s == 'A' ? p.values.sum : 0 }.sum
