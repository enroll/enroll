class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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
end
