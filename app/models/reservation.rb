class Reservation < ActiveRecord::Base
  belongs_to :course
  belongs_to :student, class_name: 'User'

  delegate :instructor, to: :course

  validates :course,  presence: true
  validates :student, presence: true

  after_create :send_enrollment_notification
  after_create :check_campaign_success

  def charged?
    charge_succeeded_at.present?
  end

  def send_enrollment_notification
    Resque.enqueue EnrollmentNotification, id
  end

  def send_enrollment_notification!
    InstructorMailer.student_enrolled(self).deliver
  end

  def check_campaign_success
    if course.students.count == course.min_seats
      Resque.enqueue CampaignSuccessNotification, course.id
      Resque.enqueue ChargeCreditCards, course.id
    end
  end
end
