require 'benchmark'

def produce_n(n_recipes)
  current_recipes = [0, 1]
  recipes = [3, 7]
  loop do
    new_recipe_score = recipes[current_recipes[0]] + recipes[current_recipes[1]]
    recipes = recipes + new_recipe_score.to_s.chars.map(&:to_i)

    current_recipes[0] = (current_recipes[0] + 1 + recipes[current_recipes[0]]) % (recipes.size)
    current_recipes[1] = (current_recipes[1] + 1 + recipes[current_recipes[1]]) % (recipes.size)

    break if recipes.size >= n_recipes
  end
  recipes
end

def ten_after(n_recipes)
  produce_n(n_recipes + 10)[n_recipes..n_recipes + 9].join
end

puts Benchmark.measure { p ten_after(5) }
puts Benchmark.measure { p ten_after(18) }
puts Benchmark.measure { p ten_after(2018) }

# leading zeros in ruby integers, LOL!
# p produce!(030121)
puts Benchmark.measure { p ten_after(30121) }

####### 2nd part #######

def index_of(score)
  current_recipes = [0, 1]
  recipes = "37"

  result = nil

  loop do
    recipes << (recipes[current_recipes[0]].to_i + recipes[current_recipes[1]].to_i).to_s

    current_recipes[0] = (current_recipes[0] + 1 + recipes[current_recipes[0]].to_i) % (recipes.size)
    current_recipes[1] = (current_recipes[1] + 1 + recipes[current_recipes[1]].to_i) % (recipes.size)

    result = (recipes[-10..-1] || recipes).index(score)
    break if result
  end

  recipes.size - 10 + result
end

puts Benchmark.measure { p index_of('51589') }
puts Benchmark.measure { p index_of('01245') }
puts Benchmark.measure { p index_of('92510') }
puts Benchmark.measure { p index_of('59414') }
puts Benchmark.measure { p index_of('030121') }
