class Course < ActiveRecord::Base
  has_many :reservations
end
