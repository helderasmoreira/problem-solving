require 'date'

input = File.readlines('4.input', chomp: true)

Log = Struct.new(:year, :month, :day, :hour, :minute, :type, :guard_id, :timestamp) do
  def initialize(year, month, day, hour, minute, type, guard_id)
    super(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, type, guard_id.to_i)
    self.timestamp = DateTime.new(self.year, self.month, self.day, self.hour, self.minute)
  end
end

logs = input.map do |log|
  Log.new(*log.scan(/(\d+)-(\d+)-(\d+) (\d+):(\d+). (Guard|wakes|falls) #?(\d+)?/).flatten)
end.sort_by { |log| log.timestamp }.chunk { |n| n.type == 'Guard' }.map(&:last)

EnhancedLog = Struct.new(:guard_id, :asleep)

enhanced_logs =
  logs.each_slice(2).map(&:flatten).map do |a|
    entered, rest = a[0], a[1..-1]

    asleep = Array.new(60) { false }
    rest.each_slice(2) { |logs| (logs.first.minute...logs.last.minute).each { |minute| asleep[minute] = true } }

    EnhancedLog.new(entered.guard_id, asleep)
  end

# output similar to the one in the example!
# enhanced_logs.each { |x| puts "#{x.guard_id} #{x.asleep.map { |x| x ? '#' : '.' }.join('')}" }

totals = Hash.new { |h, k| h[k] = Hash.new(0) }

enhanced_logs.each do |log|
  log.asleep.each_with_index do |e, i|
    totals[log.guard_id][i] += 1 if e
  end
end

guard_id = totals.max_by { |_, v| v.values.reduce(:+) }.first
minute = totals[guard_id].max_by { |_, v| v }.first

p minute * guard_id

####### 2nd part #######

overall_guard_id = totals.max_by { |_, v| v.values.max }.first
overall_minute = totals[overall_guard_id].max_by { |_, v| v }.first

p overall_guard_id * overall_minute
