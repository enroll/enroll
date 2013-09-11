class StudentMailer < ActionMailer::Base
  include MailersHelper

  def campaign_failed(course, student)
    @student    = student
    @instructor = course.instructor
    @course     = course

    mail \
      :to       => @student.email,
      :from     => enroll_noreply,
      :subject  => "[#{@course.name}] Your course didn't reach its minimum reservations."
  end

  def campaign_succeeded(course, student)
    @student    = student
    @instructor = course.instructor
    @course     = course

    mail \
      :to       => @student.email,
      :from     => enroll_noreply,
      :subject  => "[#{@course.name}] Get ready! Your course reached its minimum reservations."
  end

  def campaign_ending_soon(course, student)
    @student    = student
    @instructor = course.instructor
    @course     = course

    mail \
      :to       => @student.email,
      :from     => enroll_noreply,
      :subject  => "[#{@course.name}] Course needs your help!"
  end
end
