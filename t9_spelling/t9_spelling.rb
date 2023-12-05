
require 'benchmark'

class T9Spelling

  T9_TABLE = {
    a: '2',
    b: '22',
    c: '222',
    d: '3',
    e: '33',
    f: '333',
    g: '4',
    h: '44',
    i: '444',
    j: '5',
    k: '55',
    l: '555',
    m: '6',
    n: '66',
    o: '666',
    p: '7',
    q: '77',
    r: '777',
    s: '7777',
    t: '8',
    u: '88',
    v: '888',
    w: '9',
    x: '99',
    y: '999',
    z: '9999',
    ' '.to_sym => '0',
    "\n".to_sym => '',
  }

  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          output << %Q{Case ##{test_case}: #{translate_to_t9(input.readline.split(""))}\n}
        end
      end
    end
  end

  def translate_to_t9(phrase)
    t9_output = ''
    phrase.each do |character|
      # check if needs pause
      t9_output += ' ' if t9_output[-1, 1] == T9_TABLE[character.to_sym][0]

      # convert char to t9
      t9_output += T9_TABLE[character.to_sym].to_s
    end
    t9_output
  end
end

problem = T9Spelling.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('C-small-practice.in') }
  x.report('large') { problem.solve('C-large-practice.in') }
end
