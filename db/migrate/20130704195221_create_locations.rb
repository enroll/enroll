class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.float :lat
      t.float :lng

      t.timestamps
    end

    add_column :courses, :location_id, :integer
    add_index :courses, :location_id
  end

end
