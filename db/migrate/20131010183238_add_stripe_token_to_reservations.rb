class AddStripeTokenToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :stripe_token, :string
  end
end
