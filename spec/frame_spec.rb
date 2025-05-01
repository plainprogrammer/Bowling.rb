# frozen_string_literal: true

require_relative '../lib/frame'

RSpec.describe Frame do
  context "regular frame" do
    subject(:frame) { Frame.new(1) }

    it "starts with no rolls" do
      expect(frame.rolls).to be_empty
    end

    it "can add a roll" do
      frame.add_roll(5)
      expect(frame.rolls).to eq([5])
    end

    it "calculates the score as the sum of rolls" do
      frame.add_roll(5)
      frame.add_roll(3)
      expect(frame.score).to eq(8)
    end

    it "is complete after two rolls" do
      frame.add_roll(5)
      frame.add_roll(3)
      expect(frame).to be_complete
    end

    it "is complete after a strike" do
      frame.add_roll(10)
      expect(frame).to be_complete
    end

    it "identifies a strike correctly" do
      frame.add_roll(10)
      expect(frame).to be_strike
    end

    it "identifies a spare correctly" do
      frame.add_roll(5)
      frame.add_roll(5)
      expect(frame).to be_spare
    end

    it "identifies an open frame correctly" do
      frame.add_roll(5)
      frame.add_roll(3)
      expect(frame).to be_open
    end

    it "rejects invalid number of pins" do
      expect { frame.add_roll(-1) }.to raise_error(ArgumentError)
      expect { frame.add_roll(11) }.to raise_error(ArgumentError)
    end

    it "rejects pins that would exceed 10 in a frame" do
      frame.add_roll(5)
      expect { frame.add_roll(6) }.to raise_error(ArgumentError)
    end

    it "rejects too many rolls in a frame" do
      frame.add_roll(5)
      frame.add_roll(3)
      expect { frame.add_roll(2) }.to raise_error(RuntimeError)
    end
  end

  context "tenth frame" do
    subject(:tenth_frame) { Frame.new(10) }

    it "allows three rolls after a strike" do
      tenth_frame.add_roll(10)
      tenth_frame.add_roll(10)
      tenth_frame.add_roll(10)
      expect(tenth_frame.rolls).to eq([10, 10, 10])
      expect(tenth_frame).to be_complete
    end

    it "allows three rolls after a spare" do
      tenth_frame.add_roll(5)
      tenth_frame.add_roll(5)
      tenth_frame.add_roll(10)
      expect(tenth_frame.rolls).to eq([5, 5, 10])
      expect(tenth_frame).to be_complete
    end

    it "allows only two rolls for an open tenth frame" do
      tenth_frame.add_roll(5)
      tenth_frame.add_roll(4)
      expect(tenth_frame).to be_complete
      expect { tenth_frame.add_roll(2) }.to raise_error(RuntimeError)
    end

    it "correctly identifies as last frame" do
      expect(tenth_frame).to be_last_frame
    end
  end
end