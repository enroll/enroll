class AddCourseSeats < ActiveRecord::Migration
  def change
    add_column :courses, :min_seats, :integer
    add_column :courses, :max_seats, :integer
    add_column :courses, :price_per_seat, :integer
    add_column :courses, :instructor_biography, :text
  end
end
