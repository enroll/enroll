class AddUserIdToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :user_id, :integer
    add_index :reservations, :user_id
  end
end
