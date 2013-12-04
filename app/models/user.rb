class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :account_number, :routing_number, :stripe_bank_account_token

  has_many :reservations, dependent: :destroy, foreign_key: :student_id
  has_many :courses_as_student, through: :reservations,
    class_name: 'Course', source: :course, foreign_key: :student_id
  has_many :courses_as_instructor, class_name: 'Course',
    foreign_key: :instructor_id, dependent: :destroy
  has_many :events

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

  def save_payment_settings!(params)
    params[:type] = "individual"
    params[:bank_account] = params.delete(:stripe_bank_account_token)
    params[:email] = self.email

    begin
      recipient = Stripe::Recipient.create(params)

      if recipient && recipient.id
        self.stripe_recipient_id = recipient.id
        self.name = params[:name]
        save
      else
        false
      end
    rescue Stripe::InvalidRequestError => e
      return false
    end
  end

  # TODO: Add a 'role' column to actually distinguish
  # between Enroll staff and Enroll customers
  def staff?
    true
  end
end
