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

    10.times do |frame|
      if spare?(roll_index)
        total_score += 10 + @rolls[roll_index + 2].to_i
        roll_index += 2
      else
        total_score += @rolls[roll_index].to_i + @rolls[roll_index + 1].to_i
        roll_index += 2
      end
    end

    total_score
  end

  private

  def spare?(roll_index)
    @rolls[roll_index].to_i + @rolls[roll_index + 1].to_i == 10
  end
end
