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

  def campaign_failed(course)
    @instructor = course.instructor
    @students   = course.students
    @course     = course

    mail \
      :to       => @instructor.email,
      :from     => enroll_reply,
      :subject  => "[#{@course.name}] Course didn't meet reach your minimum reservations"
  end

  def campaign_succeeded(course)
    @instructor = course.instructor
    @students   = course.students
    @course     = course

    mail \
      :to       => @instructor.email,
      :from     => enroll_reply,
      :subject  => "[#{@course.name}] Congrats! Your course has met your minimums."
  end
end
