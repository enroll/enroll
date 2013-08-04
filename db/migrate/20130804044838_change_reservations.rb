class ChangeReservations < ActiveRecord::Migration
  def change
    rename_column :reservations, :user_id, :student_id
  end
end
