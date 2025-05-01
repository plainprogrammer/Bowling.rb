class BowlingGame
  def initialize
    @rolls = []
    @current_roll = 0
  end

  def roll(pins)
    if pins < 0 || pins > 10
      raise ArgumentError, "Invalid number of pins: #{pins}. Must be between 0 and 10."
    end
    
    # Check if this is a second roll in a frame and total exceeds 10
    if frame_in_progress? && !last_frame? && @rolls[@current_roll - 1] + pins > 10
      raise ArgumentError, "Invalid number of pins: total pins in a frame cannot exceed 10."
    end
    
    @rolls[@current_roll] = pins
    @current_roll += 1
  end

  def score
    total_score = 0
    roll_index = 0

    # Score for frames 1-9
    9.times do
      if strike?(roll_index)
        total_score += 10 + strike_bonus(roll_index)
        roll_index += 1
      elsif spare?(roll_index)
        total_score += 10 + spare_bonus(roll_index)
        roll_index += 2
      else
        total_score += sum_of_pins_in_frame(roll_index)
        roll_index += 2
      end
    end

    # Score for the 10th frame
    if strike?(roll_index)
      total_score += 10 + @rolls[roll_index + 1].to_i + @rolls[roll_index + 2].to_i
    elsif spare?(roll_index)
      total_score += 10 + @rolls[roll_index + 2].to_i
    else
      total_score += @rolls[roll_index].to_i + @rolls[roll_index + 1].to_i
    end

    total_score
  end

  private

  def frame_in_progress?
    # Returns true if we're on a second roll of a frame
    @current_roll > 0 && @current_roll % 2 == 1 && @rolls[@current_roll - 1] != 10
  end

  def last_frame?
    # Calculate which frame we're in
    frame = 0
    roll_index = 0
    
    while roll_index < @current_roll
      if roll_index < 18 && @rolls[roll_index] == 10
        # Strike
        frame += 1
        roll_index += 1
      else
        # Open frame or spare
        frame += 1
        roll_index += 2
      end
      
      break if frame >= 10
    end
    
    frame == 10
  end

  def strike?(roll_index)
    @rolls[roll_index].to_i == 10
  end

  def spare?(roll_index)
    @rolls[roll_index].to_i + @rolls[roll_index + 1].to_i == 10
  end

  def strike_bonus(roll_index)
    @rolls[roll_index + 1].to_i + @rolls[roll_index + 2].to_i
  end

  def spare_bonus(roll_index)
    @rolls[roll_index + 2].to_i
  end

  def sum_of_pins_in_frame(roll_index)
    @rolls[roll_index].to_i + @rolls[roll_index + 1].to_i
  end
end
