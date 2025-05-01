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
    
    context 'tenth frame special rules' do
      it 'gives a bonus roll after a spare in the tenth frame' do
        game = BowlingGame.new
        # Roll 9 frames (18 rolls) of 0
        18.times { game.roll(0) }
        # Tenth frame spare + bonus
        game.roll(5)
        game.roll(5) # Spare in 10th frame
        game.roll(8) # Bonus roll
        expect(game.score).to eq(18) # 0 for first 9 frames + 10 + 8 for the tenth
      end
      
      it 'gives two bonus rolls after a strike in the tenth frame' do
        game = BowlingGame.new
        # Roll 9 frames (18 rolls) of 0
        18.times { game.roll(0) }
        # Tenth frame strike + 2 bonuses
        game.roll(10) # Strike in 10th frame
        game.roll(8)  # Bonus roll 1
        game.roll(7)  # Bonus roll 2
        expect(game.score).to eq(25) # 0 for first 9 frames + 10 + 8 + 7 for the tenth
      end
      
      it 'computes the score correctly with multiple strikes at the end' do
        game = BowlingGame.new
        # Roll 9 frames (18 rolls) of 0
        18.times { game.roll(0) }
        # Tenth frame - all strikes
        game.roll(10) # Strike in 10th frame
        game.roll(10) # Bonus roll 1 (strike)
        game.roll(10) # Bonus roll 2 (strike)
        expect(game.score).to eq(30) # 0 for first 9 frames + 10 + 10 + 10 for the tenth
      end
      
      it 'does not allow more than 3 rolls in the tenth frame' do
        game = BowlingGame.new
        # Roll 9 frames (18 rolls) 
        18.times { game.roll(1) }
        # Tenth frame with strike + 2 bonuses
        game.roll(10)
        game.roll(10)
        game.roll(10)
        # This roll should not be counted
        game.roll(10)
        expect(game.score).to eq(48) # 18 for first 9 frames + 30 for the tenth
      end
    end
  end
end