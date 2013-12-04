class Event < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  COURSE_CREATED = 'course_created'
  PAGE_VISITED = 'page_visited'
  STUDENT_ENROLLED = 'student_enrolled'

  belongs_to :course
  belongs_to :user

  validates :event_type, :presence => true

  before_create :store_date

  def to_s
    if event_type == COURSE_CREATED
      "Course created"
    elsif event_type == PAGE_VISITED
      "#{self.count} students visited landing page."
    elsif event_type == STUDENT_ENROLLED
      "#{pluralize(self.count, 'student')} enrolled!"
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

  def self.grouped_by_date_and_type(options)
    course = options[:course]

    events = Event
      .select('date, event_type, count(1) as count, max(created_at) ts')
      .order('ts desc')
      .where('course_id = ?', course.id)
      .group('date, event_type')

    events.to_a.group_by(&:date)
  end

  protected

  def store_date
    self.date = Date.today
  end
end
