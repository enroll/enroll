class CourseSchedule < ActiveRecord::Base
  belongs_to :course

  validates :course_id, presence: true
  validates :date, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
end