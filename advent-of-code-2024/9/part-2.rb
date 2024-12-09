require 'pry-byebug'

disk_map = File.readlines('puzzle.input', chomp: true).map { |line| line.split('') }.first

file_index = -1
expanded_map = []

disk_map.each_slice(2) do |file, space|
  file_index += 1
  expanded_map << [file_index, file.to_i]
  expanded_map << ['.', space.to_i]
end

file_index.downto(0).each do |file_ind|
  ind = expanded_map.index { |el, size| el == file_ind }
  el, size = expanded_map[ind]

  # find a suitable file to move to the left
  swap_ind = expanded_map.index { |rel, rsize| rel == '.' && rsize >= size }
  next if swap_ind.nil? || swap_ind > ind

  swap_el, swap_size = expanded_map[swap_ind]

  # move file to the "left"
  expanded_map[swap_ind] = expanded_map[ind]

  # consolidate the space left behind in the file's original position
  # surely there's a prettier way to write this
  # but... not today! :trollface:
  if expanded_map[ind - 1][0] == '.' && expanded_map[ind + 1][0] == '.'
    expanded_map[ind - 1][1] += size
    expanded_map[ind - 1][1] += expanded_map[ind + 1][1]
    expanded_map.delete_at(ind + 1)
    expanded_map.delete_at(ind)
  elsif expanded_map[ind - 1][0] == '.'
    expanded_map[ind - 1][1] += size
    expanded_map.delete_at(ind)
  elsif expanded_map[ind + 1][0] == '.'
    expanded_map[ind + 1][1] += size
    expanded_map.delete_at(ind)
  else
    expanded_map[ind] = ['.', size]
  end

  # adjust the space in the file new position
  # because the new file might not taka all the space
  diff = swap_size - size
  if diff > 0
    if expanded_map[swap_ind + 1][0] == '.'
      expanded_map[swap_ind + 1][1] = expanded_map[swap_ind + 1][1] + diff
    else
      expanded_map.insert(swap_ind + 1, ['.', diff])
    end
  end
end

ind = 0
acc = 0
checksum =
  expanded_map.each do |el, size|
    size.times do
      acc += el.to_i * ind if el != '.'
      ind += 1
    end
  end

puts acc
