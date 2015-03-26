require 'benchmark'

class AlienLanguage
  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        first_line = input.readline.split(' ').map { |x| x.to_i }
        alien_words = []
        1.upto(first_line[1]) do |alien_word|
          alien_words = alien_words + [input.readline]
        end

        1.upto(first_line[2]) do |test_case|
          possible_options = analyze_pattern(alien_words, input.readline.chomp)
          output << %Q{Case ##{test_case}: #{possible_options}\n}
        end
      end
    end
  end

  def analyze_pattern(alien_words, word)
    word.gsub!(/\((.*?)\)/, '[\1]')

    matches = 0
    alien_words.each do |alien_word|
      matches += 1 if alien_word.match(word)
    end
    matches
  end
end

problem = AlienLanguage.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('A-small-practice.in') }
  x.report('large') { problem.solve('A-large-practice.in') }
end
