class Course < ActiveRecord::Base
  has_many :reservations

  validates :name, presence: true

  # temporary while we figure out what db columns we want...
  attr_accessor :tagline, :location, :start_time, :start_date, :description, :motivation, :audience
end
