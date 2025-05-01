# frozen_string_literal: true

class Frame
  attr_reader :rolls, :frame_number
  
  def initialize(frame_number)
    @rolls = []
    @frame_number = frame_number
  end
  
  def add_roll(pins)
    validate_pins(pins)
    validate_frame_state
    @rolls << pins
  end
  
  def score
    @rolls.sum
  end
  
  def complete?
    if last_frame?
      # Tenth frame is complete after:
      # - three rolls
      # - two rolls if open frame (neither strike nor spare)
      (@rolls.size == 3) || (@rolls.size == 2 && !strike? && !spare?)
    else
      # Regular frame is complete after:
      # - one roll if it's a strike
      # - two rolls otherwise
      strike? || @rolls.size == 2
    end
  end
  
  def strike?
    @rolls.size >= 1 && @rolls[0] == 10
  end
  
  def spare?
    @rolls.size >= 2 && !strike? && (@rolls[0] + @rolls[1] == 10)
  end
  
  def open?
    @rolls.size == 2 && !strike? && !spare?
  end
  
  def last_frame?
    @frame_number == 10
  end
  
  private
  
  def validate_pins(pins)
    if pins.negative? || pins > 10
      raise ArgumentError, "Invalid number of pins: #{pins}. Must be between 0 and 10."
    end
    
    if !last_frame? && @rolls.size == 1 && (@rolls[0] + pins) > 10
      raise ArgumentError, "Invalid number of pins: #{pins}. Total pins in frame cannot exceed 10."
    end
    
    if last_frame? && @rolls.size == 1 && !strike? && (@rolls[0] + pins) > 10
      raise ArgumentError, "Invalid number of pins: #{pins}. Total pins in frame cannot exceed 10."
    end
  end
  
  def validate_frame_state
    if !last_frame? && complete?
      raise RuntimeError, "Cannot add more rolls to a completed frame."
    end
    
    if last_frame?
      if @rolls.size >= 3
        raise RuntimeError, "Cannot add more than three rolls to the 10th frame."
      elsif @rolls.size == 2 && !strike? && !spare?
        raise RuntimeError, "Cannot add a third roll to the 10th frame without a strike or spare."
      end
    end
  end
end