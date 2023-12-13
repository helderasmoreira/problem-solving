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
    # if there's no more string
    # if right side is empty or if right side is a match to the last set of #, it's a good one
    # if not, it's a bad one and does not match
    (r.empty? || (r.size == 1 && nr_w == r[0])) ? 1 : 0
  when '.'
    if nr_w.zero?
      # if we were not in the middle of a # streak, just move on
      analyse_and_cache(l_tail, r, 0)
    elsif nr_w == r[0]
      # if we were in the middle of a # streak, consume that number from the right because it matches
      # it is still a possible case
      analyse_and_cache(l_tail, r[1..], 0)
    else
      # if we were in the middle of a # streak that ended and does not match
      # it's a bad scenario
      0
    end
  when '#'
    # if there is no right side at this point, it's a bad scenario
    return 0 if r.nil? || r.empty?

    nr_w += 1
    # we've seen one more #, the number needs to still be lower or equal to the next right block
    # for it to continue in contention
    return 0 if nr_w > r[0]

    # consume one from the left, keep analysing
    analyse_and_cache(l_tail, r, nr_w)
  when '?'
    # it could be a # or a .
    # so let's fork and add the possibilities for the two scenarios
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
