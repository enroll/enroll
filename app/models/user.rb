class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :courses, foreign_key: :instructor_id

  def current_course
    (next_course || most_recent_course || courses.first) if courses.any?
  end

  def next_course
    courses.future.first
  end

  def most_recent_course
    courses.past.first
  end

  def display_title
    email
  end
end
