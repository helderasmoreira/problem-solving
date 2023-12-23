require 'pry-byebug'
require 'set'

grid = File.readlines('puzzle.input', chomp: true).map { |line| line.split('') }
finish = [grid.size - 2, grid.first.size - 2]
start = [1, 1]

options = {}
grid.each.with_index do |row, r_i|
  row.each.with_index do |value, c_i|
    next if value == '#'

    poptions = [
      [r_i + 1, c_i],
      [r_i - 1, c_i],
      [r_i, c_i + 1],
      [r_i, c_i - 1]
    ].select do |o_ri, o_ci|
      grid[o_ri][o_ci] != '#'
    end

    options[[r_i, c_i]] = poptions
  end
end

def run_until_finish(start, finish, options)
  to_visit = [[start, 1, Set.new]]
  results = []

  while current = to_visit.shift
    node, score, visited = current
    r, c = node

    puts to_visit.size

    if [r, c] == finish
      results << score + 1
    else
      options[[r, c]].each do |o_node, o_weight|
        o_r, o_c = o_node
        next if visited.include? o_node

        to_visit << [o_node, score + o_weight, visited + [[o_r, o_c]]]
      end
    end
  end

  results
end

def run_until_intersection_or_exits(start, exits, options)
  to_visit = [[start, 0]]
  visited = Set.new
  result = []

  while current = to_visit.shift
    node, score = current
    r, c = node

    visited << [r, c]

    if [r, c] != start && (options[[r, c]].size > 2 || exits.include?([r, c]))
      result << [[r, c], score]
    else
      options[[r, c]].each do |option_r, option_c|
        next if visited.include? [option_r, option_c]

        to_visit << [[option_r, option_c], score + 1]
      end
    end
  end
  result
end

compact_options = {}
([start, finish] + options.select { |k, v| v.size > 2 }.keys).each do |node|
  compact_options[node] ||= []

  result = run_until_intersection_or_exits(node, [start, finish], options)
  compact_options[node] += result
end

p run_until_finish(start, finish, compact_options).max
