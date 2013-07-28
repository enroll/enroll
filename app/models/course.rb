class Course < ActiveRecord::Base
  has_many :reservations, dependent: :destroy
  belongs_to :location
  belongs_to :instructor, class_name: 'User'

  validates :name, presence: true
  validates :location, associated: true
  validates :instructor, associated: true

  scope :future, -> { where("starts_at >= ?", Time.now).order("starts_at ASC") }
  scope :past, -> { where("starts_at < ?", Time.now).order("starts_at DESC") }
  scope :without_dates, -> { where(starts_at: nil) }

  after_save :set_defaults

  # temporary while we figure out what db columns we want...
  attr_accessor :motivation, :audience

  def start_date
    starts_at.try(:strftime, "%a, %B %e %Y")
  end

  def start_time
    starts_at.try(:strftime, "%l:%M %p %Z")
  end

  def end_time
    ends_at.try(:strftime, "%l:%M %p %Z")
  end

  def location_attributes=(location_attributes)
    location_attributes.delete_if { |k, v| v.blank? }
    if location_attributes.any?
      self.location = Location.where(location_attributes).first_or_create
    end
  end

  private

  # temporary
  def set_defaults
    self.ends_at = self.starts_at + 4.hours if self.starts_at_changed?
  end
end
