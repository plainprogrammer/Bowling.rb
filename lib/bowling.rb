# frozen_string_literal: true

require_relative 'frame'

class Bowling
  def initialize
    @frames = []
    start_frame(1)
  end
  
  def roll(pins)
    validate_game_state
    @current_frame.add_roll(pins)
    
    if @current_frame.complete? && @frames.size < 10
      start_frame(@frames.size + 1)
    end
  end
  
  def score
    total = 0
    @frames.each_with_index do |frame, index|
      total += frame.score
      
      if frame.strike?
        total += strike_bonus(index)
      elsif frame.spare?
        total += spare_bonus(index)
      end
    end
    total
  end
  
  def frame_scores
    result = []
    running_total = 0
    
    @frames.each_with_index do |frame, index|
      if !frame.complete? || 
         (frame.strike? && !enough_rolls_after_strike?(index)) ||
         (frame.spare? && !enough_rolls_after_spare?(index))
        result << nil
      else
        frame_score = frame.score
        frame_score += strike_bonus(index) if frame.strike?
        frame_score += spare_bonus(index) if frame.spare?
        running_total += frame_score
        result << running_total
      end
    end
    
    result
  end
  
  def game_complete?
    @frames.size == 10 && @frames.last.complete?
  end
  
  def current_frame_number
    @current_frame.frame_number
  end
  
  private
  
  def start_frame(number)
    @current_frame = Frame.new(number)
    @frames << @current_frame
  end
  
  def validate_game_state
    if game_complete?
      raise RuntimeError, "Game is complete. Cannot add more rolls."
    end
  end
  
  def strike_bonus(frame_index)
    bonus = 0
    next_rolls = next_rolls_after(frame_index, 2)
    bonus = next_rolls.sum if next_rolls.size == 2
    bonus
  end
  
  def spare_bonus(frame_index)
    bonus = 0
    next_rolls = next_rolls_after(frame_index, 1)
    bonus = next_rolls.first if next_rolls.size == 1
    bonus
  end
  
  def next_rolls_after(frame_index, count)
    rolls = []
    
    if frame_index < @frames.size - 1
      next_frame_index = frame_index + 1
      
      while next_frame_index < @frames.size && rolls.size < count
        frame = @frames[next_frame_index]
        rolls.concat(frame.rolls)
        next_frame_index += 1
      end
    end
    
    rolls.slice(0, count)
  end
  
  def enough_rolls_after_strike?(frame_index)
    next_rolls_after(frame_index, 2).size == 2 || @frames[frame_index].last_frame?
  end
  
  def enough_rolls_after_spare?(frame_index)
    next_rolls_after(frame_index, 1).size == 1 || @frames[frame_index].last_frame?
  end
end