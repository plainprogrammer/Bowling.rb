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
    # We'll implement this later
    0
  end
end
