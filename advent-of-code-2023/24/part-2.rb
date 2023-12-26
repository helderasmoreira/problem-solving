require 'pry-byebug'

lines = File.readlines('puzzle.input', chomp: true).take(3).map do |line|
  l, r = line.split(' @ ')
  l = l.split(', ').map(&:to_r)
  r = r.split(', ').map(&:to_r)

  m = ((l[1] + r[1]) - l[1]) / ((l[0] + r[0]) - l[0])
  b = l[1] - (m * l[0])

  [l, r, m, b]
end

index = 0
lines.each do |line|
  l, r = line
  variable = ('a'..'z').to_a[index]

  puts "eq#{index} = x+w*#{variable}==#{l[0].to_i}+#{r[0].to_i}*#{variable}"
  puts "eq#{index + 1} = y+r*#{variable}==#{l[1].to_i}+#{r[1].to_i}*#{variable}"
  puts "eq#{index + 2} = z+p*#{variable}==#{l[2].to_i}+#{r[2].to_i}*#{variable}"
  index += 3
end

# Use SageMath to solve the equations:
# var('x,y,z,w,r,p,a,d,g')
# eq0 = x+w*a==119566840879742+18*a
# eq1 = y+r*a==430566433235378+-130*a
# eq2 = z+p*a==268387686114969+74*a
# eq3 = x+w*d==433973471892198+-16*d
# eq4 = y+r*d==260061119249300+-170*d
# eq5 = z+p*d==263051300077633+-118*d
# eq6 = x+w*g==44446443386018+197*g
# eq7 = y+r*g==281342848485672+16*g
# eq8 = z+p*g==166638492241385+200*g
# h = solve([eq0,eq1,eq2,eq3,eq4,eq5,eq6,eq7,eq8],[x,y,z,w,r,p,a,d,g])
# h[0]
