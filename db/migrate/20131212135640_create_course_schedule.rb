class CreateCourseSchedule < ActiveRecord::Migration
  def change
    create_table :course_schedules do |t|
      t.integer :course_id
      t.date :date
      t.integer :starts_at # Number of seconds from midnight
      t.integer :ends_at   # ...
    end
  end
end
