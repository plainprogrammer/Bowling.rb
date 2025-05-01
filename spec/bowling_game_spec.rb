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
  end
end
