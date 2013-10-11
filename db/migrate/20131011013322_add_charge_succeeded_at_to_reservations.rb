class AddChargeSucceededAtToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :charge_succeeded_at, :datetime
  end
end
