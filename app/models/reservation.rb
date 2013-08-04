class Reservation < ActiveRecord::Base
  belongs_to :course
  belongs_to :student, class_name: 'User'

  validates :course,  presence: true
  validates :student, presence: true
end
