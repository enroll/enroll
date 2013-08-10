class InstructorMailer < ActionMailer::Base
  include MailersHelper

  def student_enrolled(reservation)
    @student    = reservation.student
    @instructor = reservation.instructor
    @course     = reservation.course

    mail \
      :to       => @instructor.email,
      :from     => enroll_noreply,
      :subject  => "[#{@course.name}] A new student has enrolled"
  end
end
