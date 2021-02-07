require 'benchmark'

class DeceitfulWar
  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          input.readline.to_i # consume the nr_blocks
          naomi = input.readline.split.map(&:to_f)
          ken = input.readline.split.map(&:to_f)
          naomi.sort!
          ken.sort!
          output << %Q{Case ##{test_case}: #{deceitful_war(naomi.dup, ken.dup)} #{war(naomi.dup, ken.dup)}\n}
        end
      end
    end
  end

  def war(naomi, ken)
    naomi_pts = 0

    while (naomi_block = naomi.pop)
      # ken looks for his smallest block that is bigger than naomi's
      ken_best_option = -1
      # avoid using select {}.min
      ken.each_with_index do |n, i|
        if n > naomi_block
          ken_best_option = i
          break
        end
      end

      if ken_best_option == -1 # didn't found one to win, so uses the smallest possible and let naomi win
        ken.shift
        naomi_pts += 1
      else
        # ken wins
        ken.delete_at(ken_best_option)
      end
    end
    naomi_pts
  end

  def deceitful_war(naomi, ken)
    naomi_pts = 0
    rounds = naomi.size

    1.upto(rounds) do
      if ken.last > naomi.last
        # ken has the biggest block, so naomi deceives him into using it
        # and uses her smallest one
        naomi.shift
        ken.pop
      elsif naomi.last > ken.last
        # naomi can win right away, but she deceives ken still
        # by letting him think she will use a block bigger
        # than she will in truth
        ken_choice = ken.pop

        naomi_best_option = -1
        # avoid using select {}.min
        naomi.each_with_index do |n, i|
          if n > ken_choice
            naomi_best_option = i
            break
          end
        end
        naomi.delete_at(naomi_best_option)
        naomi_pts += 1
      end
    end
    naomi_pts
  end
end

problem = DeceitfulWar.new
Benchmark.bm do |x|
  x.report('test') { problem.solve('test.in') }
  x.report('small') { problem.solve('D-small-practice.in') }
  x.report('large') { problem.solve('D-large-practice.in') }
end
