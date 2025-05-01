class BowlingGame
  def initialize
    @rolls = []
  end
  
  def roll(pins)
    @rolls << pins
  end
  
  def score
    score_for_frames
  end
  
  private
  
  def score_for_frames
    total_score = 0
    roll_index = 0
    
    # There are 10 frames in a bowling game
    (0...10).each do |_|
      # Check if we have enough rolls to process
      break if roll_index >= @rolls.size
      
      if strike?(roll_index)
        # Strike: 10 pins plus bonus of next two rolls
        strike_bonus = (@rolls[roll_index + 1] || 0) + (@rolls[roll_index + 2] || 0)
        total_score += 10 + strike_bonus
        roll_index += 1  # Move to next roll (only 1 roll used in this frame)
      elsif spare?(roll_index)
        # Spare: 10 pins plus bonus of next roll
        spare_bonus = @rolls[roll_index + 2] || 0
        total_score += 10 + spare_bonus
        roll_index += 2  # Move to next frame (2 rolls used in this frame)
      else
        # Normal frame: sum of the two rolls (or just one roll if that's all we have)
        first_roll = @rolls[roll_index]
        second_roll = roll_index + 1 < @rolls.size ? @rolls[roll_index + 1] : 0
        total_score += first_roll + second_roll
        roll_index += 2  # Move to next frame (2 rolls used in this frame)
      end
    end
    
    total_score
  end
  
  def strike?(roll_index)
    @rolls[roll_index] == 10
  end
  
  def spare?(roll_index)
    return false if roll_index + 1 >= @rolls.size
    !strike?(roll_index) && @rolls[roll_index] + @rolls[roll_index + 1] == 10
  end
end