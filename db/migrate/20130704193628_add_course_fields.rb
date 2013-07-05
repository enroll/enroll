class AddCourseFields < ActiveRecord::Migration
  def change
    add_column :courses, :tagline, :string
    add_column :courses, :course_starts_at, :datetime
    add_column :courses, :course_ends_at, :datetime
    add_column :courses, :description, :text
  end
end
