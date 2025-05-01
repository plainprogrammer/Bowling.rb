class BowlingGame
  class InvalidPinsError < StandardError; end
  
  def initialize
    @rolls = []
  end
  
  def roll(pins)
    validate_pins(pins)
    
    # Don't add rolls beyond what's allowed in a game
    return if max_rolls_reached?
    
    @rolls << pins
  end
  
  def max_rolls_reached?
    return false if @rolls.empty?
    
    # Count frames to determine if we've reached max rolls
    frames = 0
    roll_index = 0
    
    # Process rolls to count complete frames
    while roll_index < @rolls.size && frames < 9
      if @rolls[roll_index] == 10  # Strike
        frames += 1
        roll_index += 1
      elsif roll_index + 1 < @rolls.size  # Have at least 2 rolls
        frames += 1
        roll_index += 2
      else
        roll_index += 1  # Only one roll left, move to next
      end
    end
    
    # Now handle the 10th frame
    if frames == 9
      remaining_rolls = @rolls.size - roll_index
      
      # If first roll of 10th frame is a strike, allow up to 3 rolls
      if roll_index < @rolls.size && @rolls[roll_index] == 10
        return remaining_rolls >= 3
      end
      
      # If first two rolls of 10th frame are a spare (and not a strike), allow up to 3 rolls
      if roll_index + 1 < @rolls.size && 
         @rolls[roll_index] < 10 &&  # First roll isn't a strike
         @rolls[roll_index] + @rolls[roll_index + 1] == 10  # It's a spare
        return remaining_rolls >= 3
      end
      
      # Otherwise only allow 2 rolls for 10th frame
      return remaining_rolls >= 2
    end
    
    false
  end
  
  def score
    score_for_frames
  end
  
  private
  
  def validate_pins(pins)
    # Pins should be a number between 0 and 10
    if !pins.is_a?(Integer) || pins < 0 || pins > 10
      raise InvalidPinsError, "Invalid pins value: #{pins}. Must be an integer between 0 and 10."
    end
  end
  
  def score_for_frames
    total_score = 0
    roll_index = 0
    
    # Process the first 9 frames
    (0...9).each do |_|
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
    
    # Handle the 10th frame specially
    if roll_index < @rolls.size
      # First roll of 10th frame
      first_roll = @rolls[roll_index]
      total_score += first_roll
      
      # If strike in first roll, we get up to two more rolls
      if first_roll == 10
        # Add second roll if it exists
        if roll_index + 1 < @rolls.size
          second_roll = @rolls[roll_index + 1]
          total_score += second_roll
          
          # Add third roll if it exists (after a strike in first roll)
          if roll_index + 2 < @rolls.size
            third_roll = @rolls[roll_index + 2]
            total_score += third_roll
          end
        end
      else
        # If not a strike, check for second roll
        if roll_index + 1 < @rolls.size
          second_roll = @rolls[roll_index + 1]
          total_score += second_roll
          
          # If it's a spare (first + second = 10, and first is not 10), get one more roll
          if first_roll < 10 && first_roll + second_roll == 10
            if roll_index + 2 < @rolls.size
              third_roll = @rolls[roll_index + 2]
              total_score += third_roll
            end
          end
          
          # Note: If second roll is a strike but first roll is not, no bonus rolls
          # This is handled by not adding any additional rolls beyond the second
        end
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