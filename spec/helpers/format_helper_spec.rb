require 'spec_helper'

describe FormatHelper do
  context "#price_in_dollars" do
    it "returns the price in dollars" do
      helper.price_in_dollars(19999).should == 199.99
    end

    it "returns nil if no price is passed in" do
      helper.price_in_dollars(nil).should == nil
    end
  end
end

