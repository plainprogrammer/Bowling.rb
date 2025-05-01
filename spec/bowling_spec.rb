# frozen_string_literal: true

require 'bowling'

RSpec.describe BowlingGame do
  let(:game) { BowlingGame.new }

  def roll_many(rolls, pins)
    rolls.times { game.roll(pins) }
  end

  def roll_spare
    game.roll(5)
    game.roll(5)
  end

  def roll_strike
    game.roll(10)
  end

  it 'scores a gutter game as 0' do
    roll_many(20, 0)
    expect(game.score).to eq(0)
  end

  it 'scores a game of all ones as 20' do
    roll_many(20, 1)
    expect(game.score).to eq(20)
  end

  it 'scores a spare correctly' do
    roll_spare
    game.roll(3)
    roll_many(17, 0)
    expect(game.score).to eq(16) # 10 (spare) + 3 (bonus) + 3 (next frame first roll)
  end

  it 'scores a strike correctly' do
    roll_strike
    game.roll(3)
    game.roll(4)
    roll_many(16, 0)
    expect(game.score).to eq(24) # 10 (strike) + 3 (bonus) + 4 (bonus) + 3 (next frame first) + 4 (next frame second)
  end

  it 'scores a perfect game as 300' do
    12.times { roll_strike }
    expect(game.score).to eq(300)
  end

  it 'scores a game ending with a spare' do
    roll_many(18, 0)
    roll_spare # 10th frame
    game.roll(7) # Bonus roll
    expect(game.score).to eq(17)
  end

  it 'scores a game ending with a strike' do
    roll_many(18, 0)
    roll_strike # 10th frame
    game.roll(7)
    game.roll(2) # Bonus rolls
    expect(game.score).to eq(19)
  end

  it 'raises an error for negative pins' do
    expect { game.roll(-1) }.to raise_error(ArgumentError, 'Pins must be a non-negative integer.')
  end

  it 'raises an error for more than 10 pins in a roll' do
    expect { game.roll(11) }.to raise_error(ArgumentError, 'Cannot knock down more than 10 pins in a roll.')
  end

  # TODO: Add test for invalid frame score (e.g., 6 + 5)
end
