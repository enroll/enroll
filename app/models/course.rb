class Course < ActiveRecord::Base
  has_many :reservations

  validates :name, presence: true

  # temporary while we figure out what db columns we want...
  attr_accessor :tagline, :location, :start_time, :start_date, :description,
                 :motivation, :audience, :location_street_address, :location_name,
                 :location_city, :location_state, :location_zip, :location_phone
end
