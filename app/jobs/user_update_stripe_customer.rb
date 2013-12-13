class UserUpdateStripeCustomer
  @queue = :notifications

  def self.perform(user_id, card_token)
    User.find(user_id).update_stripe_customer(card_token)
  end
end