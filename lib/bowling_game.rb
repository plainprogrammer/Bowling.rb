# frozen_string_literal: true

class BowlingGame
  def initialize
    @frames = []
    @current_frame = []
  end

  def roll(pins)
    raise "Invalid number of pins" if pins < 0 || pins > 10

    if @frames.size < 9
      handle_regular_frame(pins)
    else
      handle_tenth_frame(pins)
    end
  end

  def score
    total_score = 0
    @frames.each_with_index do |frame, index|
      total_score += frame.sum

      if strike?(frame) && index < 9
        total_score += strike_bonus(index)
      elsif spare?(frame) && index < 9
        total_score += spare_bonus(index)
      end
    end

    total_score
  end

  private

  def strike?(frame)
    frame.size == 1 && frame.first == 10
  end

  def spare?(frame)
    frame.size == 2 && frame.sum == 10
  end

  def strike_bonus(index)
    next_frame = @frames[index + 1]
    second_next_frame = @frames[index + 2]

    if next_frame
      if strike?(next_frame) && second_next_frame
        10 + second_next_frame.first.to_i
      else
        next_frame[0..1].sum
      end
    else
      0
    end
  end

  def spare_bonus(index)
    @frames[index + 1]&.first.to_i
  end

  def handle_regular_frame(pins)
    @current_frame << pins
    if @current_frame.sum == 10 || @current_frame.size == 2
      @frames << @current_frame
      @current_frame = []
    end
  end

  def handle_tenth_frame(pins)
    @current_frame << pins
    if @current_frame.size == 3 || (@current_frame.size == 2 && @current_frame.sum < 10)
      @frames << @current_frame
      @current_frame = []
    end
  end
end