require 'pry-byebug'

CACHE = {}

def analyse_and_cache(l, r, nr_w)
  analyse(l, r, nr_w).tap { |value| CACHE[[l, r, nr_w]] = value }
end

def analyse(l, r, nr_w)
  return CACHE[[l, r, nr_w]] if CACHE.has_key?([l, r, nr_w])

  l_tail = l[1..]

  case l[0]
  when nil
    (r.empty? || (r.size == 1 && nr_w == r[0])) ? 1 : 0
  when '.'
    if nr_w.zero?
      analyse_and_cache(l_tail, r, 0)
    elsif nr_w == r[0]
      analyse_and_cache(l_tail, r[1..], 0)
    else
      0
    end
  when '#'
    return 0 if r.nil? || r.empty?

    nr_w += 1
    return 0 if nr_w > r[0]

    analyse_and_cache(l_tail, r, nr_w)
  when '?'
    analyse_and_cache(['#'] + l_tail, r, nr_w) + analyse_and_cache(['.'] + l_tail, r, nr_w)
  end
end

n_ways = File.readlines('puzzle.input', chomp: true).map do |line|
  l, r = line.split(' ')
  l = l.split('') + ((['?'] + l.split('')) * 4)
  r = r.split(',').map(&:to_i) * 5

  analyse(l, r, 0)
end

puts n_ways.sum
