class Reservation < ActiveRecord::Base
  belongs_to :course
  belongs_to :student, class_name: 'User'

  delegate :instructor, to: :course

  validates :course,  presence: true
  validates :student, presence: true
end
