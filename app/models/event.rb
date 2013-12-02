class Event < ActiveRecord::Base
  COURSE_CREATED = 'course_created'

  belongs_to :course
  belongs_to :user

  validates :event_type, :presence => true

  def to_s
    if event_type == COURSE_CREATED
      "Course created"
    end
  end
end
