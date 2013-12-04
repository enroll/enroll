class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :event_type
      t.integer :course_id
      t.integer :user_id

      t.timestamps
    end
  end
end
