require 'spec_helper'

describe Payout do
  let(:payout) { build(:payout) }

  context "validations" do
    it "requires an 'amount_in_cents'" do
      payout.amount_in_cents = nil
      payout.valid?
      payout.errors[:amount_in_cents].should include("can't be blank")
    end

    it "requires a 'description' of what bank transfer will say" do
      payout.description = nil
      payout.valid?
      payout.errors[:description].should include("can't be blank")
    end

    it "requires a 'stripe_recipient_id'" do
      payout.stripe_recipient_id = nil
      payout.valid?
      payout.errors[:stripe_recipient_id].should include("can't be blank")
    end
  end

  it "starts in the 'pending' status" do
    payout.status.should == 'pending'
  end

  context "#transfer" do
    before { Payout.any_instance.stubs(:request_stripe_transfer!).returns(true) }

    it "updates the status to 'transfer_requested" do
      payout.transfer
      payout.status.should == 'transfer_requested'
    end

    # TODO: Bring in VCR or stub out Stripe somehow
    #it "creates a Stripe::Transfer" do
      #payout = build(:payout, :description => "Ruby Fundamentals", :amount_in_cents => 14000, :stripe_recipient_id => 12345)

      #Stripe::Transfer.expects(:create).with({
        #:amount => 140000,
        #:currency => 'usd',
        #:recipient => 12345,
        #:statement_descriptor => "Ruby Fundamentals"
      #})

      #payout.transfer!
    #end
  end

  context "#transfer_complete" do
    it "updates the status to 'paid'" do
      payout = build(:payout_requested)
      payout.transfer_complete
      payout.status.should == 'paid'
    end
  end
end
