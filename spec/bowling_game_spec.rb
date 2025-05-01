require 'bowling_game'

RSpec.describe BowlingGame do
  let(:game) { BowlingGame.new }

  def roll_many(times, pins)
    times.times { game.roll(pins) }
  end

  describe '#score' do
    context 'gutter game' do
      it 'scores 0' do
        roll_many(20, 0)
        expect(game.score).to eq(0)
      end
    end

    context 'all ones' do
      it 'scores 20' do
        roll_many(20, 1)
        expect(game.score).to eq(20)
      end
    end

    context 'one spare' do
      it 'adds bonus for spare' do
        game.roll(5)
        game.roll(5)
        game.roll(3)
        roll_many(17, 0)
        expect(game.score).to eq(16)
      end
    end

    context 'one strike' do
      it 'adds bonus for strike' do
        game.roll(10)
        game.roll(3)
        game.roll(4)
        roll_many(16, 0)
        expect(game.score).to eq(24)
      end
    end

    context 'perfect game' do
      it 'scores 300' do
        roll_many(12, 10)
        expect(game.score).to eq(300)
      end
    end
  end
end
