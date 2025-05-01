# frozen_string_literal: true

class Bowling
  def initialize
    @rolls = []
  end

  def roll(pins)
    validate_roll(pins)
    @rolls << pins
  end

  def score
    score = 0
    roll_index = 0

    10.times do |frame|
      if strike?(roll_index)
        # Strike
        score += 10 + strike_bonus(roll_index)
        roll_index += 1
      elsif spare?(roll_index)
        # Spare
        score += 10 + spare_bonus(roll_index)
        roll_index += 2
      else
        # Open frame
        score += @rolls[roll_index].to_i + @rolls[roll_index + 1].to_i
        roll_index += 2
      end
    end

    score
  end

  def current_frame
    return 1 if @rolls.empty?
    
    frame = 1
    roll_idx = 0
    
    while roll_idx < @rolls.size
      # If we're in the 10th frame already, stay there until game is complete
      break if frame >= 10
      
      # If it's a strike, move to next frame
      if @rolls[roll_idx] == 10
        frame += 1
        roll_idx += 1
      else
        # For non-strikes, we need two rolls to complete a frame
        # If we have recorded both rolls, move to next frame
        if roll_idx + 1 < @rolls.size
          frame += 1
          roll_idx += 2
        else
          # If we only have one roll recorded, stay in current frame
          break
        end
      end
    end
    
    [frame, 10].min  # Never go beyond the 10th frame
  end

  def frame_complete?(frame)
    return false if frame > current_frame
    
    true
  end

  def frame_score_at(frame)
    return 0 if frame > 10 || frame <= 0
    
    score = 0
    roll_index = 0
    current_frame = 1

    while current_frame <= frame
      if strike?(roll_index)
        score += 10 + strike_bonus(roll_index) if current_frame == frame
        roll_index += 1
      elsif spare?(roll_index)
        score += 10 + spare_bonus(roll_index) if current_frame == frame
        roll_index += 2
      else
        score += @rolls[roll_index].to_i + @rolls[roll_index + 1].to_i if current_frame == frame
        roll_index += 2
      end
      
      current_frame += 1
    end

    score
  end

  private

  def validate_roll(pins)
    if pins < 0 || pins > 10
      raise "Invalid number of pins: #{pins}"
    end

    # Check for invalid second roll in a frame (exceeding 10 total pins)
    frame_rolls = get_current_frame_rolls
    
    # Handle second roll validation
    if !frame_rolls.empty? && frame_rolls.size == 1 && !in_final_frame?
      # If this is the second roll in a non-final frame
      if frame_rolls.first + pins > 10
        raise "Invalid number of pins: #{pins}, total exceeds 10"
      end
    end

    # Check if game is complete
    if game_complete?
      raise "Game is over. No more rolls allowed."
    end
  end

  # Helper to get the rolls recorded for the current frame
  def get_current_frame_rolls
    return [] if @rolls.empty?
    
    frame = 1
    roll_idx = 0
    frame_start_idx = 0
    
    while frame < current_frame && roll_idx < @rolls.size
      frame_start_idx = roll_idx
      
      if @rolls[roll_idx] == 10
        # Strike
        roll_idx += 1
        frame += 1
      else
        # Non-strike
        roll_idx += 2
        frame += 1
      end
    end
    
    # Now roll_idx points to the first roll of the current frame
    if in_final_frame?
      # For final frame, return all remaining rolls (up to 3)
      @rolls[frame_start_idx..]
    else
      # For regular frames, return recorded rolls in current frame (up to 2)
      if roll_idx < @rolls.size && @rolls[roll_idx] == 10
        # Strike - just one roll in this frame
        [@rolls[roll_idx]]
      else
        # Non-strike - up to two rolls in this frame
        @rolls[roll_idx..(roll_idx + 1)].compact
      end
    end
  end

  def strike?(roll_index)
    roll_index < @rolls.size && @rolls[roll_index] == 10
  end

  def spare?(roll_index)
    roll_index + 1 < @rolls.size && @rolls[roll_index] + @rolls[roll_index + 1] == 10
  end

  def strike_bonus(roll_index)
    bonus = 0
    bonus += @rolls[roll_index + 1].to_i if roll_index + 1 < @rolls.size
    bonus += @rolls[roll_index + 2].to_i if roll_index + 2 < @rolls.size
    bonus
  end

  def spare_bonus(roll_index)
    roll_index + 2 < @rolls.size ? @rolls[roll_index + 2] : 0
  end

  def in_final_frame?
    frame_count = 0
    roll_index = 0

    while roll_index < @rolls.size
      frame_count += 1
      
      break if frame_count >= 10
      
      if strike?(roll_index)
        roll_index += 1
      else
        roll_index += 2
      end
    end

    frame_count == 10
  end

  def game_complete?
    frame_count = 0
    roll_index = 0

    while roll_index < @rolls.size
      if frame_count == 9
        # In the 10th frame
        if strike?(roll_index)
          # Strike in 10th frame - need two more rolls
          return roll_index + 3 <= @rolls.size
        elsif spare?(roll_index)
          # Spare in 10th frame - need one more roll
          return roll_index + 3 <= @rolls.size
        else
          # Open frame in 10th
          return roll_index + 2 <= @rolls.size
        end
      end

      frame_count += 1
      
      if strike?(roll_index)
        roll_index += 1
      else
        roll_index += 2
      end
    end

    false
  end
end