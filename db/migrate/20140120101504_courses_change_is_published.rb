class CoursesChangeIsPublished < ActiveRecord::Migration
  def change
    remove_column :courses, :is_published, :boolean
    add_column :courses, :published_at, :datetime
  end
end
