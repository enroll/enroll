require "spec_helper"

describe MarketingToken do
  it "generates random tokens" do
    token1 = MarketingToken.generate!
    token2 = MarketingToken.generate!

    token1.token.should_not be_nil
    token2.token.should_not be_nil

    token1.distinct_id.should_not be_nil
    token2.distinct_id.should_not be_nil

    token1.token.should_not == token2.token
    token1.distinct_id.should_not == token2.distinct_id
  end
end