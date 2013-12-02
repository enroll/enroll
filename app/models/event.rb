class Event < ActiveRecord::Base
  COURSE_CREATED = 'course_created'
  PAGE_VISITED = 'page_visited'

  belongs_to :course
  belongs_to :user

  validates :event_type, :presence => true

  def to_s
    if event_type == COURSE_CREATED
      "Course created"
    elsif event_type == PAGE_VISITED
      "Page visited"
    else
      "???"
    end
  end

  def self.create_event(event_type, options = {})
    event = Event.new
    event.event_type = event_type
    event.course = options[:course]
    event.user = options[:user]
    event.save!
  end
end
