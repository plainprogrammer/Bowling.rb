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
      
      it 'correctly handles a spare in the first two rolls of the tenth frame' do
        game = BowlingGame.new
        # Roll 9 frames (18 rolls) of 0
        18.times { game.roll(0) }
        # Tenth frame spare + bonus
        game.roll(5)
        game.roll(5) # Spare in 10th frame
        game.roll(8) # Bonus roll
        expect(game.score).to eq(18) # 0 for first 9 frames + 10 + 8 for the tenth
      end
      
      it 'correctly calculates score when a strike is made on the second roll of the tenth frame' do
        game = BowlingGame.new
        # Roll 9 frames (18 rolls) of 0
        18.times { game.roll(0) }
        # Tenth frame with first roll and then a strike + bonus
        game.roll(0)
        game.roll(10) # Strike in second roll of 10th frame
        game.roll(8)  # Bonus roll
        expect(game.score).to eq(18) # 0 for first 9 frames + 10 + 8 for the tenth
      end
      
      it 'handles a partial tenth frame with a strike on first roll' do
        game = BowlingGame.new
        # Roll 9 frames (18 rolls) of 0
        18.times { game.roll(0) }
        # Tenth frame with only one strike
        game.roll(10) # Strike in 10th frame
        # No additional rolls - should calculate correctly with available rolls
        expect(game.score).to eq(10) # 0 for first 9 frames + 10 for the tenth (no bonus)
      end
      
      it 'handles a partial tenth frame with a spare' do
        game = BowlingGame.new
        # Roll 9 frames (18 rolls) of 0
        18.times { game.roll(0) }
        # Tenth frame with spare only
        game.roll(5)
        game.roll(5) # Spare in 10th frame
        # No additional rolls - should calculate correctly with available rolls
        expect(game.score).to eq(10) # 0 for first 9 frames + 10 for the tenth (no bonus)
      end
      
      it 'correctly calculates a complex tenth frame with strikes in different positions' do
        game = BowlingGame.new
        # Roll 9 frames with all strikes
        9.times { game.roll(10) }
        # Tenth frame with 3 strikes
        game.roll(10) # First roll of 10th frame (strike)
        game.roll(10) # Second roll (bonus)
        game.roll(10) # Third roll (bonus)
        expect(game.score).to eq(300) # Perfect game
        
        # Test another scenario with strikes
        game2 = BowlingGame.new
        # Roll 9 frames with all 0s
        18.times { game2.roll(0) }
        # Complex 10th frame with strike pattern
        game2.roll(10) # First roll
        game2.roll(5)  # Second roll (bonus)
        game2.roll(3)  # Third roll (bonus)
        expect(game2.score).to eq(18) # 0 + 10 + 5 + 3
      end
      
      it 'handles the case of a non-strike first roll followed by a strike in the tenth frame' do
        game = BowlingGame.new
        # Roll 9 frames with all 0s
        18.times { game.roll(0) }
        # Tenth frame with a non-strike followed by a strike
        game.roll(5)   # First roll 
        game.roll(10)  # Second roll (strike)
        # This should not add a bonus roll since this isn't a spare or starting with strike
        game.roll(5)   # This roll should be ignored
        expect(game.score).to eq(15) # 0 + 5 + 10
      end
      
      it 'correctly limits rolls for different tenth frame scenarios' do
        # Scenario 1: Strike on first roll of tenth frame
        game1 = BowlingGame.new
        18.times { game1.roll(0) }
        game1.roll(10) # Strike on first roll of tenth frame
        game1.roll(3)  # First bonus roll
        game1.roll(4)  # Second bonus roll
        game1.roll(5)  # This should be ignored (exceeds max rolls)
        expect(game1.score).to eq(17) # 10 + 3 + 4
        
        # Scenario 2: Spare in tenth frame
        game2 = BowlingGame.new
        18.times { game2.roll(0) }
        game2.roll(6)  # First roll
        game2.roll(4)  # Second roll (spare)
        game2.roll(7)  # Bonus roll
        game2.roll(8)  # This should be ignored (exceeds max rolls)
        expect(game2.score).to eq(17) # 6 + 4 + 7
        
        # Scenario 3: Open frame in tenth frame
        game3 = BowlingGame.new
        18.times { game3.roll(0) }
        game3.roll(3)  # First roll
        game3.roll(4)  # Second roll (no spare)
        game3.roll(5)  # This should be ignored (exceeds max rolls)
        expect(game3.score).to eq(7) # 3 + 4
      end
    end
    
    context 'input validation' do
      it 'raises an error for negative pins' do
        game = BowlingGame.new
        expect { game.roll(-1) }.to raise_error(BowlingGame::InvalidPinsError)
      end
      
      it 'raises an error for pins greater than 10' do
        game = BowlingGame.new
        expect { game.roll(11) }.to raise_error(BowlingGame::InvalidPinsError)
      end
      
      it 'raises an error for non-integer pins' do
        game = BowlingGame.new
        expect { game.roll(5.5) }.to raise_error(BowlingGame::InvalidPinsError)
      end
    end
  end
end