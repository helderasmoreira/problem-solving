MOVES = {
  'A' => :rock,
  'B' => :paper,
  'C' => :scissors,
}

OUTCOMES = {
  'X' => :loss,
  'Y' => :draw,
  'Z' => :win,
}

POINTS = {
  rock: 1,
  paper: 2,
  scissors: 3
}

input = File.readlines('puzzle.input', chomp: true).map { |line| line.split.map { |move| MOVES[move] || OUTCOMES[move] } }

score = 0
input.each do |round|
  move =
    case round.last
    when :loss
      case round.first
        when :scissors
          :paper
        when :rock
          :scissors
        when :paper
          :rock
        end
    when :draw
      score += 3
      round.first
    when :win
      score += 6
      case round.first
      when :scissors
        :rock
      when :rock
        :paper
      when :paper
        :scissors
      end
    end

  score += POINTS[move]
end

puts score
