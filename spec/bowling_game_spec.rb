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
    
    it 'calculates the score with a spare' do
      game = BowlingGame.new
      game.roll(5)
      game.roll(5) # Spare
      game.roll(3)
      game.roll(0)
      expect(game.score).to eq(16) # 10 + 3 + 3
    end
    
    it 'calculates the score with multiple spares' do
      game = BowlingGame.new
      game.roll(5)
      game.roll(5) # Spare
      game.roll(3)
      game.roll(7) # Spare
      game.roll(4)
      game.roll(0)
      expect(game.score).to eq(31) # (10 + 3) + (10 + 4) + 4
    end
    
    it 'calculates the score for a game of all spares with 5 pins each roll' do
      game = BowlingGame.new
      21.times { game.roll(5) } # 10 frames with all spares + last bonus roll
      expect(game.score).to eq(150) # (10 + 5) * 10 frames
    end
    
    it 'calculates the score with a strike' do
      game = BowlingGame.new
      game.roll(10) # Strike
      game.roll(3)
      game.roll(4)
      expect(game.score).to eq(24) # 10 + 3 + 4 + 3 + 4
    end
    
    it 'calculates the score with multiple strikes' do
      game = BowlingGame.new
      game.roll(10) # Strike
      game.roll(10) # Strike
      game.roll(3)
      game.roll(4)
      expect(game.score).to eq(47) # (10 + 10 + 3) + (10 + 3 + 4) + (3 + 4)
    end
    
    it 'calculates the score for a perfect game' do
      game = BowlingGame.new
      12.times { game.roll(10) } # 12 strikes
      expect(game.score).to eq(300) # 10 strikes * 30 points
    end
  end
end