class Reservation < ActiveRecord::Base
  belongs_to :course
  belongs_to :student, class_name: 'User'

  delegate :instructor, to: :course

  validates :course,  presence: true
  validates :student, presence: true
  validate :cannot_enroll_twice_for_the_same_course

  before_create :set_charge_amount_from_course

  after_create :send_enrollment_notification
  after_create :check_campaign_success

  def charged?
    charge_succeeded_at.present?
  end

  def set_charge_amount_from_course
    self.charge_amount = course.price_per_seat_in_cents
  end

  def send_enrollment_notification
    Resque.enqueue EnrollmentNotification, id
  end

  def send_enrollment_notification!
    InstructorMailer.student_enrolled(self).deliver
  end

  def check_campaign_success
    return if course.min_seats == 0

    if course.students.count == course.min_seats
      Resque.enqueue CampaignSuccessNotification, course.id
    end

    if course.paid? && course.students.count >= course.min_seats
      Resque.enqueue ChargeCreditCards, course.id
    end
  end

  def cannot_enroll_twice_for_the_same_course
    existing = Reservation.where(student_id: student.try(:id), course_id: course.try(:id))
    unless new_record?
      existing = existing.where('id != ?', id)
    end
    if existing.first
      errors.add(:course, 'you are already enrolled for this course')
    end
  end
end
