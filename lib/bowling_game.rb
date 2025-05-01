class BowlingGame
  def initialize
    @rolls = []
    @current_roll = 0
  end

  def roll(pins)
    if pins < 0 || pins > 10
      raise ArgumentError, "Invalid number of pins: #{pins}. Must be between 0 and 10."
    end
    @rolls[@current_roll] = pins
    @current_roll += 1
  end

  def score
    total_score = 0
    roll_index = 0

    10.times do
      total_score += @rolls[roll_index].to_i + @rolls[roll_index + 1].to_i
      roll_index += 2
    end

    total_score
  end
end
