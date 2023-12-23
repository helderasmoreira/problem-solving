require 'pry-byebug'

blocks = []
Block = Struct.new(:min_x, :max_x, :min_y, :max_y, :min_z, :max_z, :blocked_by) do
  def rx
    min_x..max_x
  end

  def ry
    min_y..max_y
  end

  def rz
    min_z..max_z
  end

  def down
    Block.new(min_x, max_x, min_y, max_y, min_z - 1, max_z - 1)
  end
end

def r_intersection?(r1, r2)
  r1.include?(r2.begin) || r1.include?(r2.end) || r2.include?(r1.begin) || r2.include?(r1.end)
end

def intersection?(one, other)
  r_intersection?(one.rx, other.rx) &&
  r_intersection?(one.ry, other.ry) &&
  r_intersection?(one.rz, other.rz)
end

max_max_z = 0

File.readlines('puzzle.input', chomp: true).each_with_index do |line, index|
  l, r = line.split('~')
  min_x, min_y, min_z = l.split(',').map(&:to_i)
  max_x, max_y, max_z = r.split(',').map(&:to_i)

  max_max_z = max_z if max_max_z < max_z
  blocks << Block.new(min_x, max_x, min_y, max_y, min_z, max_z)
end

blocks.sort_by(&:min_z).each do |block|
  until block.min_z == 1
    nblock = block.down
    blocks_in_zd = blocks.select { |b| b.rz.include?(block.min_z - 1) }

    intersections = blocks_in_zd.select { |bzd| intersection?(bzd, nblock) }
    if intersections.size >= 1
      block.blocked_by = intersections
      break
    else
      block.min_z -= 1
      block.max_z -= 1
    end
  end
end

can_disintegrate = blocks.count do |b1|
  blocks.all? do |b2|
    !b2.blocked_by&.include?(b1) || b2.blocked_by&.size > 1
  end
end

puts can_disintegrate
