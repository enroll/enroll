class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :reservations, dependent: :destroy
  has_many :courses_as_student, through: :reservations, class_name: 'Course', source: :course
  has_many :courses_as_instructor, class_name: 'Course', foreign_key: :instructor_id, dependent: :destroy

  def courses
    (courses_as_instructor + courses_as_student).uniq
  end

  def display_title
    email
  end
end
