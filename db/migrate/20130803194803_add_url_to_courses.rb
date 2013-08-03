class AddUrlToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :url, :string
    add_index :courses, :url
  end
end
