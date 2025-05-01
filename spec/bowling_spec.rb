# frozen_string_literal: true

require_relative '../lib/bowling'

RSpec.describe Bowling do
  subject(:game) { Bowling.new }

  describe "basic game" do
    it "starts with frame 1" do
      expect(game.current_frame_number).to eq(1)
    end

    it "advances to the next frame after two rolls" do
      game.roll(3)
      game.roll(4)
      expect(game.current_frame_number).to eq(2)
    end

    it "advances to the next frame after a strike" do
      game.roll(10)
      expect(game.current_frame_number).to eq(2)
    end

    it "calculates score for open frames" do
      game.roll(3)
      game.roll(4)
      expect(game.score).to eq(7)
    end
  end

  describe "scoring spares" do
    it "calculates score for a spare" do
      game.roll(5)
      game.roll(5) # spare
      game.roll(3)
      game.roll(4)
      expect(game.score).to eq(20) # 10 + 3 + 7
    end
  end

  describe "scoring strikes" do
    it "calculates score for a strike" do
      game.roll(10) # strike
      game.roll(3)
      game.roll(4)
      expect(game.score).to eq(24) # 10 + 3 + 4 + 7
    end
  end

  describe "game completion" do
    it "identifies a completed game" do
      # Roll 10 frames (20 rolls of open frames)
      10.times do
        game.roll(3)
        game.roll(4)
      end
      expect(game).to be_game_complete
    end

    it "raises an error when trying to roll after game completion" do
      # Roll 10 frames (20 rolls of open frames)
      10.times do
        game.roll(3)
        game.roll(4)
      end
      expect { game.roll(5) }.to raise_error(RuntimeError)
    end
  end

  describe "perfect game" do
    it "scores 300 for a perfect game" do
      # 12 strikes (10 frames with 2 bonus rolls in the 10th frame)
      12.times { game.roll(10) }
      expect(game.score).to eq(300)
    end
  end

  describe "all spares" do
    it "calculates score for a game of all spares with 5 in the final bonus" do
      # 10 frames of spares (5+5) plus final 5
      10.times do
        game.roll(5)
        game.roll(5)
      end
      game.roll(5)
      expect(game.score).to eq(150) # (10 + 5) * 9 + 10 + 5
    end
  end

  describe "frame scores" do
    it "tracks frame scores correctly" do
      # Roll 1: Strike
      game.roll(10)
      expect(game.frame_scores[0]).to be_nil # Cannot score yet

      # Roll 2-3: 7, 2
      game.roll(7)
      game.roll(2)
      
      # Now we can score the first frame
      expect(game.frame_scores[0]).to eq(19)
      expect(game.frame_scores[1]).to eq(28)
    end
  end
end