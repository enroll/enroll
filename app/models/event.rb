class Event < ActiveRecord::Base
  validates :event_type, :presence => true
end
