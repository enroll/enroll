class CoursesIsPublished < ActiveRecord::Migration
  def change
    add_column :courses, :is_published, :bool, default: false
  end
end
