class Event < ActiveRecord::Base
  COURSE_CREATED = 'course_created'
  PAGE_VISITED = 'page_visited'

  belongs_to :course
  belongs_to :user

  validates :event_type, :presence => true

  before_create :store_date

  def to_s
    if event_type == COURSE_CREATED
      "Course created"
    elsif event_type == PAGE_VISITED
      "#{self.count} students visited landing page"
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

  protected

  def store_date
    self.date = Date.today
  end
end
