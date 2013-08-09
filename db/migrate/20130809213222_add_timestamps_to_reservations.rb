class AddTimestampsToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :created_at, :datetime
    add_column :reservations, :updated_at, :datetime
  end
end
