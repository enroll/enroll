class AddIsSkippedToCourseSchedules < ActiveRecord::Migration
  def change
    add_column :course_schedules, :is_skipped, :boolean, default: false
  end
end
