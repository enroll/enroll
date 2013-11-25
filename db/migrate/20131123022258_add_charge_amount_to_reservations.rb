class AddChargeAmountToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :charge_amount, :integer
  end
end
