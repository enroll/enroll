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

  context "#request" do
    before { payout.stubs(:transfer_funds!).returns(true) }

    it "updates the status to 'requested" do
      payout.request
      payout.status.should == 'requested'
    end

    it "requests a funds transfer" do
      payout.expects(:transfer_funds!).returns(stub_everything)
      payout.request
    end

    it "sets the transfer id" do
      payout.expects(:set_transfer_id).returns(stub_everything)
      payout.request
    end
  end

  context "#transfer_funds!" do
    it "transfers funds to a stripe recipient" do
      payout = build(:payout,
        :description         => "Ruby Fundamentals",
        :amount_in_cents     => 14000,
        :stripe_recipient_id => "rp_2FUrV5Zn4ILgfo"
      )

      VCR.use_cassette('stripe/transfer') do
        transfer = payout.transfer_funds!

        transfer.status.should    == "pending"
        transfer.recipient.should == "rp_2FUrV5Zn4ILgfo"
        transfer.amount.should    == 14000
      end
    end
  end

  context "#set_transfer_id" do
    it "sets the stripe_transfer_id from the transfer" do
      payout.transfer = stub(:id => "abc123")
      payout.set_transfer_id
      payout.stripe_transfer_id.should == "abc123"
    end

    it "handles the case where the transfer is nil" do
      payout.transfer = nil
      payout.set_transfer_id
      payout.stripe_transfer_id.should be_nil
    end
  end

  context "#transfer_params" do
    it "includes the amount" do
      payout.amount_in_cents = 1000
      payout.transfer_params[:amount].should == 1000
    end

    it "includes the currency" do
      payout.transfer_params[:currency].should == 'usd'
    end

    it "includes the stripe recipient" do
      payout.stripe_recipient_id = 54321
      payout.transfer_params[:recipient].should == 54321
    end

    it "includes the statement_descriptor" do
      payout.description = "Negotiation 101"
      payout.transfer_params[:statement_descriptor].should == "Negotiation 101"
    end
  end

  context "#complete" do
    it "updates the status to 'paid'" do
      payout = build(:payout_requested)
      payout.complete
      payout.status.should == 'paid'
    end
  end
end
