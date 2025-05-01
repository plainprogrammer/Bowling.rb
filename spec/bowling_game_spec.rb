require 'spec_helper'
require_relative '../lib/bowling_game'

RSpec.describe BowlingGame do
  let(:game) { BowlingGame.new }

  describe '#roll' do
    it 'accepts a valid number of pins' do
      expect { game.roll(5) }.not_to raise_error
    end

    it 'raises an error for negative pins' do
      expect { game.roll(-1) }.to raise_error(ArgumentError, /Invalid number of pins/)
    end

    it 'raises an error for pins greater than 10' do
      expect { game.roll(11) }.to raise_error(ArgumentError, /Invalid number of pins/)
    end
  end

  describe '#score' do
    it 'returns 0 for a gutter game' do
      20.times { game.roll(0) }
      expect(game.score).to eq(0)
    end

    it 'returns 20 for a game with all ones' do
      20.times { game.roll(1) }
      expect(game.score).to eq(20)
    end

    it 'correctly scores a spare followed by a 3' do
      game.roll(5)
      game.roll(5) # spare
      game.roll(3)
      17.times { game.roll(0) }
      expect(game.score).to eq(16)
    end

    it 'correctly scores multiple spares' do
      game.roll(5)
      game.roll(5) # spare
      game.roll(3)
      game.roll(7) # spare
      game.roll(4)
      15.times { game.roll(0) }
      expect(game.score).to eq(31)
    end

    it 'correctly scores a strike followed by 3 and 4' do
      game.roll(10) # strike
      game.roll(3)
      game.roll(4)
      16.times { game.roll(0) }
      expect(game.score).to eq(24)
    end

    it 'correctly scores multiple strikes' do
      game.roll(10) # strike
      game.roll(10) # strike
      game.roll(10) # strike
      game.roll(5)
      game.roll(3)
      12.times { game.roll(0) }
      expect(game.score).to eq(81)
    end

    it 'handles a spare in the last frame' do
      18.times { game.roll(0) }
      game.roll(5)
      game.roll(5) # spare in 10th frame
      game.roll(8) # bonus roll
      expect(game.score).to eq(18)
    end

    it 'handles a strike in the last frame' do
      18.times { game.roll(0) }
      game.roll(10) # strike in 10th frame
      game.roll(7)  # bonus roll 1
      game.roll(2)  # bonus roll 2
      expect(game.score).to eq(19)
    end

    it 'handles a perfect game (all strikes)' do
      12.times { game.roll(10) }
      expect(game.score).to eq(300)
    end
  end
end
