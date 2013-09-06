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
    @student_emails = course.students.map { |s| s.email }.to_sentence
    @course     = course

    mail \
      :to       => @instructor.email,
      :from     => enroll_reply,
      :subject  => "[#{@course.name}] Course didn't meet reach your minimum reservations"
  end
end
