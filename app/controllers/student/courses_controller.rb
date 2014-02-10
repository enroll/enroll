class Student::CoursesController < ApplicationController
  include Icalendar

  before_filter :authenticate_user!
  before_filter :find_course_as_student_by_id!
  before_filter :setup_markdown, only: [:show]

  def show
    
  end

  def calendar
    cal = Calendar.new
    course = @course

    course.schedules.each do |day|
      cal.event do
        dtstart day.starts_at_time.to_datetime
        dtend day.ends_at_time.to_datetime
        summary course.name
        location course.location.to_calendar_s
      end
    end

    cal.publish

    respond_to do |format|
      format.ics { render text: cal.to_ical }
    end

  end
end