class Reservation < ActiveRecord::Base
  belongs_to :course
  belongs_to :user

  validates :course, presence: true
end
