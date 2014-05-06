class StudentMailer < ActionMailer::Base
  include MailersHelper

  def campaign_failed(course, student)
    @student    = student
    @instructor = course.instructor
    @course     = course

    mail \
      :to       => @student.email,
      :from     => enroll_noreply,
      :subject  => "[#{@course.url_or_short_name}] Your course didn't reach its minimum reservations."
  end

  def campaign_succeeded(course, student)
    @student    = student
    @instructor = course.instructor
    @course     = course

    mail \
      :to       => @student.email,
      :from     => enroll_noreply,
      :subject  => "[#{@course.url_or_short_name}] Get ready! Your course reached its minimum reservations."
  end

  def campaign_ending_soon(course, student)
    @student    = student
    @instructor = course.instructor
    @course     = course

    mail \
      :to       => @student.email,
      :from     => enroll_noreply,
      :subject  => "[#{@course.url_or_short_name}] Course needs your help!"
  end

  def enrolled(reservation)
    @student    = reservation.student
    @course     = reservation.course

    mail \
      :to       => @student.email,
      :from     => enroll_noreply,
      :subject  => "[#{@course.url_or_short_name}] You're enrolled!"
  end
end
