# frozen_string_literal: true

class BowlingGame
  MAX_PINS = 10
  FRAMES = 10

  def initialize
    @rolls = []
  end

  # Records a roll.
  # Raises ArgumentError for invalid pin counts (negative or > MAX_PINS).
  def roll(pins)
    validate_roll(pins)
    @rolls << pins
  end

  # Calculates the total score for the game based on the rolls recorded so far.
  # Only calculates score for completed frames (including necessary bonus rolls).
  def score
    total_score = 0
    roll_index = 0
    frame = 0

    while frame < FRAMES
      if strike?(roll_index)
        # Need 2 subsequent rolls for bonus
        break unless valid_index?(roll_index + 1) && valid_index?(roll_index + 2)
        total_score += MAX_PINS + strike_bonus(roll_index)
        roll_index += 1
      elsif spare?(roll_index)
        # Need 1 subsequent roll for bonus
        break unless valid_index?(roll_index + 2)
        total_score += MAX_PINS + spare_bonus(roll_index)
        roll_index += 2
      else
        # Need 2 rolls for this open frame
        break unless valid_index?(roll_index + 1)
        # Basic validation assumes frame total <= 10 (handled by CLI)
        total_score += frame_score(roll_index)
        roll_index += 2
      end
      frame += 1
    end

    total_score
  end

  private

  # Basic validation for a single roll.
  def validate_roll(pins)
    raise ArgumentError, "Pins must be a non-negative integer." unless pins.is_a?(Integer) && pins >= 0
    raise ArgumentError, "Cannot knock down more than #{MAX_PINS} pins in a roll." if pins > MAX_PINS
  end

  def valid_index?(index)
    index < @rolls.size
  end

  def strike?(roll_index)
    valid_index?(roll_index) && @rolls[roll_index] == MAX_PINS
  end

  def spare?(roll_index)
    valid_index?(roll_index) && valid_index?(roll_index + 1) &&
      (@rolls[roll_index] + @rolls[roll_index + 1]) == MAX_PINS
  end

  def strike_bonus(roll_index)
    # Assumes valid_index?(roll_index + 1) and valid_index?(roll_index + 2) are true
    @rolls[roll_index + 1] + @rolls[roll_index + 2]
  end

  def spare_bonus(roll_index)
    # Assumes valid_index?(roll_index + 2) is true
    @rolls[roll_index + 2]
  end

  def frame_score(roll_index)
    # Assumes valid_index?(roll_index) and valid_index?(roll_index + 1) are true
    @rolls[roll_index] + @rolls[roll_index + 1]
  end
end
