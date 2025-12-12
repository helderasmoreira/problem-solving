require 'pry-byebug'

@paths = {}
@cache = {}

File.readlines('puzzle.input', chomp: true).each do |line|
  from, to = line.split(':').map(&:strip)
  @paths[from] ||= []
  to.split(' ').each { |path| @paths[from] << path }
end

def possible(current, fft, dac)
  return @cache[[current, fft, dac]] if @cache.include?([current, fft, dac])

  if current == 'out'
    (fft && dac) ? 1 : 0
  else
    @paths[current].sum do |path|
      new_fft = path == 'fft' ? true : fft
      new_dac = path == 'dac' ? true : dac
      key = [path, new_fft, new_dac]
      @cache[key] ||= possible(path, new_fft, new_dac)
    end
  end
end

puts possible('svr', false, false)
