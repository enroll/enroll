class Course < ActiveRecord::Base
  acts_as_url :name

  has_many :reservations, dependent: :destroy
  has_many :students, through: :reservations, class_name: 'User'

  belongs_to :location
  belongs_to :instructor, class_name: 'User'

  validates :name, presence: true
  validates :location, associated: true
  validates :instructor, associated: true

  validates :url, uniqueness: true,
                  format: { with: /\A[a-z\d]+([-_][a-z\d]+)*\z/i, message: 'is not a valid URL'}

  scope :future, -> { where("starts_at >= ?", Time.now).order("starts_at ASC") }
  scope :past, -> { where("starts_at < ?", Time.now).order("starts_at DESC") }
  scope :without_dates, -> { where(starts_at: nil) }
  scope :campaign_ended, -> { where("campaign_ends_at < ?", Time.now) }
  scope :campaign_not_failed, -> { where(campaign_failed_at: nil) }

  after_save :set_defaults

  # temporary while we figure out what db columns we want...
  attr_accessor :motivation, :audience

  def self.fail_campaigns
    # NOTE: We are checking for all courses that have not yet happened with a
    # campaign that has ended but with a campaign that has not failed.
    # This will repeatedly pick up courses with a campaign that succeeds, but
    # will stop finding them once the course actually happens. Odd, but would
    # require adding another boolean (campaign_succeeded_at) to narrow in
    # further. Interesting that the opposite of failure is not necessarily
    # success.

    Course.future.campaign_ended.campaign_not_failed.each do |course|
      if course.students.count < course.min_seats
        course.update_attribute :campaign_failed_at, Time.now
        Resque.enqueue CampaignFailedNotification, course.id
      end
    end
  end

  def send_campaign_failed_notifications!
    # send email to students
    # send email to teachers
  end

  def start_date
    starts_at.try(:strftime, "%a, %B %e %Y")
  end

  def start_time
    starts_at.try(:strftime, "%l:%M %p %Z")
  end

  def end_time
    ends_at.try(:strftime, "%l:%M %p %Z")
  end

  def free?
    price_per_seat_in_cents.blank? || price_per_seat_in_cents == 0
  end

  def has_students?
    reservations.count > 0
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
