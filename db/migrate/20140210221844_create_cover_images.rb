class CreateCoverImages < ActiveRecord::Migration
  def change
    create_table :cover_images do |t|
      t.integer :course_id

      t.timestamps
    end
  end
end
