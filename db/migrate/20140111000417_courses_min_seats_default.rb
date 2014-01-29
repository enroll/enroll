class CoursesMinSeatsDefault < ActiveRecord::Migration
  def change
    change_column :courses, :min_seats, :integer, default: 0
  end
end
