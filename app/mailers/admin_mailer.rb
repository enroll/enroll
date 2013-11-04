class AdminMailer < ActionMailer::Base
  include MailersHelper
  helper :navigation

  def course_created(course)
    @instructor = course.instructor
    @course     = course

    mail \
      :to       => enroll_support,
      :from     => enroll_reply,
      :subject  => "[#{@course.url_or_short_name}] New course created."
  end
end
