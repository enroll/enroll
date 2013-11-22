class AddInstructorPaidAtToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :instructor_paid_at, :datetime
  end
end
