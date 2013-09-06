class StudentMailer < ActionMailer::Base
  include MailersHelper

  def campaign_failed(course, student)
    @student    = student
    @instructor = course.instructor
    @course     = course

    mail \
      :to       => @student.email,
      :from     => enroll_noreply,
      :subject  => "[#{@course.name}] Course didn't reach minimum reservations"
  end
end
