class AddCourseSeats < ActiveRecord::Migration
  def change
    add_column    :courses, :min_seats, :integer
    add_column    :courses, :max_seats, :integer
    add_column    :courses, :price_per_seat, :integer
    add_column    :courses, :instructor_biography, :text

    rename_column :courses, :course_starts_at, :starts_at
    rename_column :courses, :course_ends_at, :ends_at
  end
end
