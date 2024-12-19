require 'pry-byebug'

input = File.readlines('puzzle.input', chomp: true)

@patterns = input.first.split(', ')
designs = input.drop(2)

@cache = {}

def can_form_design?(design, ways=0)
  return 1 if design.empty?
  return @cache[design] if @cache[design]

  @patterns.each do |token|
    if design.start_with?(token)
      ways += can_form_design?(design[token.length..])
    end
  end

  @cache[design] ||= ways
  ways
end

n_ways = 0
designs.each_with_index { |design, i| n_ways += can_form_design?(design) }

puts n_ways
