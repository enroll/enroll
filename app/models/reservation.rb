class Reservation < ActiveRecord::Base
  belongs_to :course

  validates_presence_of :course
end
