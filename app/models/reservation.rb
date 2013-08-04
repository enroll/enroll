class Reservation < ActiveRecord::Base
  belongs_to :course
  belongs_to :student, class_name: 'User'

  delegate :instructor, to: :course

  validates :course,  presence: true
  validates :student, presence: true

  after_create :send_enrollment_notification

  def send_enrollment_notification
    InstructorMailer.student_enrolled(self).deliver
  end
end
