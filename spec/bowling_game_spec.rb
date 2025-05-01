require_relative '../lib/bowling_game'

RSpec.describe BowlingGame do
  describe '#initialize' do
    it 'creates a new bowling game' do
      expect(BowlingGame.new).to be_a(BowlingGame)
    end
  end
  
  describe '#roll and #score' do
    it 'records a roll and calculates the score' do
      game = BowlingGame.new
      game.roll(5)
      expect(game.score).to eq(5)
    end
    
    it 'calculates the score for multiple rolls' do
      game = BowlingGame.new
      game.roll(5)
      game.roll(3)
      expect(game.score).to eq(8)
    end
    
    it 'calculates the score for a complete game of all 1s' do
      game = BowlingGame.new
      20.times { game.roll(1) } # 10 frames * 2 rolls
      expect(game.score).to eq(20)
    end
  end
end