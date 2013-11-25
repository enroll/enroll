class AddChargeFailureMessageToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :charge_failure_message, :string
  end
end
