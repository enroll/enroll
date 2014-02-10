class AddCourseIdToResources < ActiveRecord::Migration
  def change
    add_column :resources, :course_id, :integer
  end
end
