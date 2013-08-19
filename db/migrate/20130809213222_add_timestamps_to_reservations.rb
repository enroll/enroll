class AddTimestampsToReservations < ActiveRecord::Migration
  def change
    add_timestamps(:reservations)
  end
end
