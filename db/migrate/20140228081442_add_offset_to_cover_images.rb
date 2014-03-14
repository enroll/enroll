class AddOffsetToCoverImages < ActiveRecord::Migration
  def change
    add_column :cover_images, :offset, :float
  end
end
