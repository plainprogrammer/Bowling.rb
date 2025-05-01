require 'spec_helper'
require 'bowling_game'

RSpec.describe BowlingGame do
  let(:game) { BowlingGame.new }

  it 'scores a gutter game as 0' do
    20.times { game.roll(0) }
    expect(game.score).to eq(0)
  end

  it 'scores a game with all ones as 20' do
    20.times { game.roll(1) }
    expect(game.score).to eq(20)
  end

  it 'scores a spare correctly' do
    game.roll(5)
    game.roll(5) # spare
    game.roll(3)
    17.times { game.roll(0) }
    expect(game.score).to eq(16)
  end

  it 'scores a strike correctly' do
    game.roll(10) # strike
    game.roll(3)
    game.roll(4)
    16.times { game.roll(0) }
    expect(game.score).to eq(24)
  end

  it 'scores a perfect game as 300' do
    12.times { game.roll(10) }
    expect(game.score).to eq(300)
  end

  it 'handles the 10th frame correctly with a spare' do
    18.times { game.roll(0) }
    game.roll(5)
    game.roll(5) # spare in 10th frame
    game.roll(3)
    expect(game.score).to eq(13)
  end

  it 'handles the 10th frame correctly with a strike' do
    18.times { game.roll(0) }
    game.roll(10) # strike in 10th frame
    game.roll(3)
    game.roll(4)
    expect(game.score).to eq(17)
  end

  it 'raises an error for invalid input' do
    expect { game.roll(-1) }.to raise_error("Invalid number of pins")
    expect { game.roll(11) }.to raise_error("Invalid number of pins")
  end
end