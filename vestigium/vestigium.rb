class Vestigium
  def solve
    test_cases = $stdin.readline.to_i

    1.upto(test_cases) do |test_case|
      matrix_size = $stdin.readline.to_i

      matrix = []
      matrix_size.times do
        matrix << $stdin.readline.split.map(&:to_i)
      end

      puts "Case ##{test_case}: #{analyze(matrix)}\n"
    end
  end

  def analyze(matrix)
    k = 0
    r = Array.new(matrix.size) { 0 }
    c = Array.new(matrix.size) { 0 }

    map_columns = Array.new(matrix.size) { {} }
    map_rows = Array.new(matrix.size) { {} }

    matrix.each_with_index do |row, i|
      k += row[i]

      row.each_with_index do |element, j|
        unless c[j] == 1
          map_columns[j][element] = (map_columns[j][element] || 0) + 1
          c[j] = 1 if map_columns[j][element] > 1
        end

        unless r[i] == 1
          map_rows[i][element] = (map_rows[i][element] || 0) + 1
          r[i] = 1 if map_rows[i][element] > 1
        end
      end
    end

    "#{k} #{r.sum} #{c.sum}"
  end
end

problem = Vestigium.new
problem.solve
