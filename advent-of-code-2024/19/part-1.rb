require 'pry-byebug'

input = File.readlines('puzzle.input', chomp: true)

@patterns = input.first.split(', ')
designs = input.drop(2)

def can_form_design?(design)
  return true if design.empty?

  @patterns.each do |token|
    if design.start_with?(token)
      if can_form_design?(design[token.length..])
        return true
      end
    end
  end

  false
end

puts designs.count { |design| can_form_design?(design) }
