class Payout < ActiveRecord::Base
  validates_presence_of :amount_in_cents, :description, :stripe_recipient_id

  state_machine :status, :initial => :pending do
    before_transition :on => :transfer, :do => :request_stripe_transfer!

    # Request a transfer of funds
    event :request do
      transition :pending => :requested
    end

    # A funds transfer has been completed
    event :complete do
      transition :requested => :paid
    end
  end

  private

  def request_stripe_transfer!
    Stripe::Transfer.create({
      :amount               => self.amount_in_cents,
      :currency             => 'usd',
      :recipient            => self.stripe_recipient_id,
      :statement_descriptor => self.description
    })
  end
end
