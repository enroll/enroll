class Instructor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :courses

  def current_course
    return nil if courses.count == 0

    if courses.future.count > 0
      courses.future.first
    elsif courses.past.count > 0
      courses.past.first
    else
      courses.first
    end
  end

  def display_title
    email
  end
end
