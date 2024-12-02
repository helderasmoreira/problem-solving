reports = []

File.readlines('puzzle.input', chomp: true).each do |line|
  reports << line.split(' ').map(&:to_i)
end

def is_safe?(report)
  direction = nil

  report.each_cons(2).all? do |l, r|
    delta = l - r

    direction ||= delta <=> 0
    ((delta <=> 0) == direction) && (delta.abs >= 1 && delta.abs <= 3)
  end
end

safe, unsafe = reports.partition { |report| is_safe?(report) }

unsafe_safe =
  unsafe.select do |report|

    i = 0
    is_safe = false
    i.upto(report.size) do |n|
      new_report = report.dup.tap { |r| r.delete_at(n) }
      is_safe = is_safe?(new_report)

      break if is_safe
    end

    is_safe
  end

puts safe.size + unsafe_safe.size
