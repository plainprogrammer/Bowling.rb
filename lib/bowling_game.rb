class BowlingGame
  def initialize
    @rolls = []
  end

  def roll(pins)
    raise ArgumentError, "Invalid pin count" if pins < 0 || pins > 10
    @rolls << pins
  end

  def score
    total = 0
    roll_index = 0
    10.times do
      if strike?(roll_index)
        total += 10 + strike_bonus(roll_index)
        roll_index += 1
      elsif spare?(roll_index)
        total += 10 + spare_bonus(roll_index)
        roll_index += 2
      else
        total += frame_points(roll_index)
        roll_index += 2
      end
    end
    total
  end

  private

  def strike?(idx)
    @rolls[idx] == 10
  end

  def spare?(idx)
    @rolls[idx] + @rolls[idx + 1] == 10
  end

  def strike_bonus(idx)
    @rolls[idx + 1].to_i + @rolls[idx + 2].to_i
  end

  def spare_bonus(idx)
    @rolls[idx + 2].to_i
  end

  def frame_points(idx)
    @rolls[idx].to_i + @rolls[idx + 1].to_i
  end
end