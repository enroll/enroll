class Payout < ActiveRecord::Base
  validates_presence_of :amount_in_cents, :description, :stripe_recipient_id

  state_machine :status, :initial => :pending do
    before_transition :on => :request, :do => :transfer_funds!

    # Request a transfer of funds
    event :request do
      transition :pending => :requested
    end

    # A funds transfer has been completed
    event :complete do
      transition :requested => :paid
    end
  end

  # Required parameters for transferring funds:
  # https://stripe.com/docs/tutorials/sending-transfers
  #
  def transfer_params
    {
      :amount               => amount_in_cents,
      :currency             => 'usd',
      :recipient            => stripe_recipient_id,
      :statement_descriptor => description
    }
  end

  # Initiate a funds transfer
  def transfer_funds!
    Stripe::Transfer.create(transfer_params)
  end

end
