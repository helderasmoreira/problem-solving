reports = []

File.readlines('puzzle.input', chomp: true).each do |line|
  reports << line.split(' ').map(&:to_i)
end

safe =
  reports.select do |report|
    direction = nil

    report.each_cons(2).all? do |l, r|
      delta = l - r

      direction ||= delta <=> 0
      ((delta <=> 0) == direction) && (delta.abs >= 1 && delta.abs <= 3)
    end
  end

puts safe.size
