require 'pry-byebug'

instruction = File.readlines('puzzle.input', chomp: true).join
matches = instruction.scan(/mul\((\d{1,3}),(\d{1,3})\)|(do\(\))|(don\'t\(\))/i).to_a.flatten.compact

on_matches = []
on = true
matches.each do |m|
  case m
  when "don't()"
    on = false
  when "do()"
    on = true
  else
    on_matches << m.to_i if on
  end
end

puts on_matches.each_slice(2).map { |a, b| a * b }.sum
