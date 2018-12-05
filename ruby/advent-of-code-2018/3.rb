input = File.readlines('3.input', chomp: true)

Claim = Struct.new(:id, :x, :y, :dx, :dy)

claims = input.map { |claim| Claim.new(*claim.scan(/(\d+)/).flatten.map(&:to_i)) }

SIZE = 1000
fabric = Array.new(SIZE) { Array.new(SIZE, 0) }

claims.each do |claim|
  (claim.x..(claim.x + claim.dx - 1)).each do |x|
    (claim.y..(claim.y + claim.dy - 1)).each do |y|
      fabric[x][y] += 1
    end
  end
end

p fabric.map { |x| x.count { |v| v > 1 } }.inject(:+)

####### 2nd part #######

no_conflicts =
  claims.find do |claim|
    (claim.x..(claim.x + claim.dx - 1)).all? do |x|
      (claim.y..(claim.y + claim.dy - 1)).all? do |y|
        fabric[x][y] == 1
      end
    end
  end

p no_conflicts
