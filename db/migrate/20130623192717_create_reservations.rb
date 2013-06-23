class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :course_id
    end

    add_index :reservations, :course_id
  end
end
