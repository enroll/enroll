class Payout < ActiveRecord::Base
  validates_presence_of :amount_in_cents, :description, :stripe_recipient_id

  attr_accessor :transfer

  state_machine :status, :initial => :pending do
    after_transition :on => :request, :do => [:transfer_funds!, :set_transfer_id]

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
    self.transfer = Stripe::Transfer.create(transfer_params)
  end

  def set_transfer_id
    if transfer && transfer.id
      self.stripe_transfer_id = transfer.id
    end
  end

end
