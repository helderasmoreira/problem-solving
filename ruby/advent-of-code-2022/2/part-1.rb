MOVES = {
  'A' => :rock,
  'B' => :paper,
  'C' => :scissors,
  'X' => :rock,
  'Y' => :paper,
  'Z' => :scissors,
}

POINTS = {
  rock: 1,
  paper: 2,
  scissors: 3
}

input = File.readlines('puzzle.input', chomp: true).map { |line| line.split.map { |move| MOVES[move] } }

score = 0

input.each do |round|
  score += POINTS[round.last]

  case round.last
  when :rock
    if round.first == :scissors
      score += 6
    elsif round.first == :rock
      score += 3
    end
  when :paper
    if round.first == :rock
      score += 6
    elsif round.first == :paper
      score += 3
    end
  when :scissors
    if round.first == :paper
      score += 6
    elsif round.first == :scissors
      score += 3
    end
  end
end

puts score
