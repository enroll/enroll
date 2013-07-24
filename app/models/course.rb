class Course < ActiveRecord::Base
  has_many :reservations, dependent: :destroy
  belongs_to :location
  belongs_to :instructor

  validates :name, presence: true
  validates :location, associated: true
  validates :instructor, associated: true

  scope :future, -> { where("course_starts_at >= ?", Date.today.to_datetime)}
  scope :past, -> { where("course_starts_at < ?", Date.today.to_datetime)}

  after_save :set_defaults

  # temporary while we figure out what db columns we want...
  attr_accessor :motivation, :audience

  def course_start_date
    return nil unless course_starts_at.present?
    course_starts_at.strftime("%a, %B %e %Y")
  end

  def course_start_time
    return nil unless course_starts_at.present?
    course_starts_at.strftime("%l:%M %p %Z")
  end

  def course_end_time
    return nil unless course_ends_at.present?
    course_ends_at.strftime("%l:%M %p %Z")
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
    self.course_ends_at = self.course_starts_at + 4.hours if self.course_starts_at_changed?
  end
end
