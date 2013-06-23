class Payout < ActiveRecord::Base
  validates_presence_of :amount_in_cents, :description, :stripe_recipient_id

  state_machine :status, :initial => :pending do
    before_transition :on => :transfer, :do => :request_stripe_transfer!

    event :transfer do
      transition :pending => :transfer_requested
    end

    event :transfer_complete do
      transition :transfer_requested => :paid
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
