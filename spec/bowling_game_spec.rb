require_relative '../lib/bowling_game'

RSpec.describe BowlingGame do
  describe '#initialize' do
    it 'creates a new bowling game' do
      expect(BowlingGame.new).to be_a(BowlingGame)
    end
  end
end