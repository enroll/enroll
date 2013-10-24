class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :account_number, :routing_number, :stripe_bank_account_token

  has_many :reservations, dependent: :destroy, foreign_key: :student_id
  has_many :courses_as_student, through: :reservations,
    class_name: 'Course', source: :course, foreign_key: :student_id
  has_many :courses_as_instructor, class_name: 'Course',
    foreign_key: :instructor_id, dependent: :destroy

  def courses
    (courses_as_instructor + courses_as_student).uniq
  end

  def display_title
    email
  end

  def reservation_for_course(course)
    Reservation.where(course_id: course.id, student_id: self.id).first
  end

  def instructor?
    courses_as_instructor.any?
  end

  def student?
    courses_as_student.any?
  end

  # TODO: Add a 'role' column to actually distinguish
  # between Enroll staff and Enroll customers
  def staff?
    true
  end
end
