class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :workshop_id
    end

    add_index :reservations, :workshop_id
  end
end
