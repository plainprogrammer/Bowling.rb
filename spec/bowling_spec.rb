# frozen_string_literal: true

require_relative "../lib/bowling"

RSpec.describe Bowling do
  let(:bowling) { Bowling.new }

  describe "#roll" do
    it "raises an error when pins is negative" do
      expect { bowling.roll(-1) }.to raise_error(RuntimeError)
    end

    it "raises an error when pins is greater than 10" do
      expect { bowling.roll(11) }.to raise_error(RuntimeError)
    end

    it "raises an error when second roll in frame exceeds limit" do
      bowling.roll(5)
      expect { bowling.roll(6) }.to raise_error(RuntimeError)
    end
  end

  describe "#score" do
    it "scores a gutter game as 0" do
      20.times { bowling.roll(0) }
      expect(bowling.score).to eq(0)
    end

    it "scores a game of all 1s as 20" do
      20.times { bowling.roll(1) }
      expect(bowling.score).to eq(20)
    end

    it "scores a spare correctly" do
      bowling.roll(5)
      bowling.roll(5) # spare
      bowling.roll(3)
      17.times { bowling.roll(0) }
      expect(bowling.score).to eq(16)
    end

    it "scores a strike correctly" do
      bowling.roll(10) # strike
      bowling.roll(3)
      bowling.roll(4)
      16.times { bowling.roll(0) }
      expect(bowling.score).to eq(24)
    end

    it "scores a perfect game as 300" do
      12.times { bowling.roll(10) }
      expect(bowling.score).to eq(300)
    end

    it "scores a game with spares in the last frame" do
      18.times { bowling.roll(0) }
      bowling.roll(5)
      bowling.roll(5) # spare in last frame
      bowling.roll(5) # bonus roll
      expect(bowling.score).to eq(15)
    end

    it "scores a game with a strike in the last frame" do
      18.times { bowling.roll(0) }
      bowling.roll(10) # strike in last frame
      bowling.roll(5)  # bonus roll
      bowling.roll(3)  # bonus roll
      expect(bowling.score).to eq(18)
    end
  end

  describe "#current_frame" do
    it "starts at frame 1" do
      expect(bowling.current_frame).to eq(1)
    end

    it "advances to frame 2 after a strike" do
      bowling.roll(10)
      expect(bowling.current_frame).to eq(2)
    end

    it "advances to frame 2 after two rolls" do
      bowling.roll(5)
      bowling.roll(4)
      expect(bowling.current_frame).to eq(2)
    end
  end

  describe "#frame_complete?" do
    it "returns true for frame with two rolls" do
      bowling.roll(3)
      bowling.roll(4)
      expect(bowling.frame_complete?(1)).to be true
    end

    it "returns true for frame with a strike" do
      bowling.roll(10)
      expect(bowling.frame_complete?(1)).to be true
    end
  end

  describe "#frame_score_at" do
    it "calculates score for a specific frame" do
      bowling.roll(1)
      bowling.roll(2)
      expect(bowling.frame_score_at(1)).to eq(3)
    end

    it "includes bonus for spare" do
      bowling.roll(5)
      bowling.roll(5) # spare
      bowling.roll(3)
      expect(bowling.frame_score_at(1)).to eq(13)
    end

    it "includes bonus for strike" do
      bowling.roll(10) # strike
      bowling.roll(3)
      bowling.roll(4)
      expect(bowling.frame_score_at(1)).to eq(17)
    end
  end
end