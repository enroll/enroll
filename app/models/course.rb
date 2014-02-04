class Course < ActiveRecord::Base
  DEFAULT_DESCRIPTION = [["About the course", "Basic details here..."], ["Prerequisites", "Things students should know..."], ["Syllabus", "Roadmap of the course..."]].map { |t| "# #{t[0]}\n\n#{t[1]}"}.join("\n\n")

  acts_as_url :name

  has_many :reservations, dependent: :destroy
  has_many :students, through: :reservations, class_name: 'User'
  has_many :events
  has_many :schedules, class_name: 'CourseSchedule'

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
  scope :campaign_ending_within, ->(future){ where("campaign_ends_at > :now AND campaign_ends_at < :future", now: Time.now, future: future) }
  scope :campaign_not_failed, -> { where(campaign_failed_at: nil) }
  scope :campaign_not_ending_soon_reminded, -> { where(campaign_ending_soon_reminded_at: nil) }

  after_save :set_defaults
  after_create :send_course_created_notification
  before_save :revert_locked_fields_if_published

  delegate :instructor_payout_amount, to: CashRegister

  # temporary while we figure out what db columns we want...
  attr_accessor :motivation, :audience

  accepts_nested_attributes_for :schedules

  def self.fail_campaigns
    # This marks campaigns that haven't reached the minimum number of seats by
    # their campaign ending time as failed, and notifies students and instructors
    # that are impacted.

    Course.future.campaign_ended.campaign_not_failed.each do |course|
      if course.students.count < course.min_seats
        course.update_attribute :campaign_failed_at, Time.now
        Resque.enqueue CampaignFailedNotification, course.id
      end
    end
  end

  # "Ending Soon" is henceforth defined as within the next 48 hours
  def self.ending_soon_time
    48.hours.from_now
  end

  def self.notify_ending_soon_campaigns
    # This marks campaigns that haven't reached the minimum number of seats by
    # their campaign ending time as reminded about ending soon, and reminds
    # students that time is drawing short.

    Course.future.campaign_not_ending_soon_reminded.campaign_ending_within(ending_soon_time).each do |course|
      if course.students.count < course.min_seats
        course.update_attribute :campaign_ending_soon_reminded_at, Time.now
        Resque.enqueue CampaignEndingSoonNotification, course.id
      end
    end
  end

  def charge_credit_cards!
    return if self.free?

    self.reservations.each do |reservation|
      next if reservation.charged?

      if reservation.stripe_token.nil? && reservation.student.stripe_customer_id.nil?
        Raven.capture_message(
          "Reservation id=#{reservation.id} has no way to be charged.",
          level: "warn",
          logger: "root"
        )
        next
      end

      unless reservation.student.stripe_customer_id
        customer = Stripe::Customer.create(
          card: reservation.stripe_token,
          description: reservation.student.email
        )
        reservation.student.update_attribute(:stripe_customer_id, customer.id)
      end

      begin
        charge = Stripe::Charge.create(
          amount: reservation.charge_amount,
          currency: 'usd',
          customer: reservation.student.stripe_customer_id
        )

        reservation.update_attributes(
          charge_succeeded_at: Time.now,
          stripe_token: nil
        )
      rescue Stripe::CardError => e
        reservation.update_attribute(:charge_failure_message, e.message)
        Raven.capture_exception(e)
      end
    end
  end

  def send_course_created_notification
    Resque.enqueue(CourseCreatedNotification, self.id)
  end

  def send_course_created_notification!
    AdminMailer.course_created(self).deliver
  end

  def send_campaign_failed_notifications!
    InstructorMailer.campaign_failed(self).deliver
    self.students.each do |student|
      StudentMailer.campaign_failed(self, student).deliver
    end
  end

  def send_campaign_ending_soon_notifications!
    self.students.each do |student|
      StudentMailer.campaign_ending_soon(self, student).deliver
    end
  end

  def send_campaign_success_notifications!
    InstructorMailer.campaign_succeeded(self).deliver
    self.students.each do |student|
      StudentMailer.campaign_succeeded(self, student).deliver
    end
  end

  def url_or_short_name
    url ? url : name.slice(0, 20)
  end

  def start_date
    starts_at.try(:strftime, "%a, %B %e, %Y")
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

  def paid?
    !free?
  end

  def price_per_seat_in_dollars
    return nil unless price_per_seat_in_cents
    price_per_seat_in_cents / 100
  end

  def price_per_seat_in_dollars=(dollars)
    self.price_per_seat_in_cents = dollars.to_f * 100
  end

  def has_students?
    reservations.count > 0
  end

  def future?
    Time.zone.now < starts_at
  end

  def past?
    !future?
  end

  def days_until_start
    days_until = (starts_at.to_date - Date.today).numerator
    days_until > 0 ? days_until : 0
  end

  def too_soon?
    if days_until_start < 14
      true
    else
      false
    end
  end

  def campaign_failed?
    campaign_failed_at.present?
  end

  def location_attributes=(all_atrs)
    atrs = all_atrs.dup
    atrs.delete_if { |k, v| v.blank? }
    if atrs.any?
      self.location = Location.where(atrs).first_or_create
    end

    self.location.try :update_attributes, all_atrs
  end

  def set_default_values_if_nil
    self.min_seats ||= 5
    self.max_seats ||= 10
    self.price_per_seat_in_cents ||= 10000
    self.build_location unless self.location
    self.description = DEFAULT_DESCRIPTION unless self.description.present?
  end

  def as_json(options={})
    {
      name: name,
      location: location || {},
      date: starts_at.try(:strftime, "%B %e, %Y"),
      description: description
    }
  end

  def instructor_paid?
    instructor_paid_at.present?
  end

  def pay_instructor!
    return false if future? || free? || instructor_paid?

    payout_result = Payout.create({
      amount_in_cents: instructor_payout_amount(self),
      description: self.name,
      stripe_recipient_id: self.instructor.stripe_recipient_id
    }).request

    update_attribute(:instructor_paid_at, Time.now) if payout_result

    payout_result
  end

  def schedules_attributes=(value)
    self.schedules.each do |schedule|
      schedule.delete
    end
    super(value)
  end

  def published?
    !!published_at
  end

  def draft?
    !published?
  end

  def publish!
    self.published_at = Time.zone.now
    self.save!
  end

  # Finishing steps of the course

  def step_finished?(step)
    required = {
      details: [:name, :url],
      dates: [:starts_at, :ends_at],
      location: ['location.name'],
      pricing: [:price_per_seat_in_cents],
      landing_page: [:has_landing_page?]
    }

    required[step].all? { |p| self.value_for_key_path(p).present? }
  end

  def all_steps_finished?
    steps = [:details, :dates, :location, :pricing, :landing_page]
    steps.all? { |s| step_finished?(s) }
  end

  def has_landing_page?
    self.description && self.description != DEFAULT_DESCRIPTION
  end

  def value_for_key_path(path)
    keys = path.to_s.split('.')

    object = self
    keys.each do |key|
      object = object.send(key)
      return nil unless object
    end

    object
  end

  private

  # temporary
  def set_defaults
    self.ends_at = self.starts_at + 4.hours if self.starts_at_changed?
  end

  def revert_locked_fields_if_published
    if published?
      self.price_per_seat_in_cents = self.price_per_seat_in_cents_was
      self.min_seats = self.min_seats_was
      self.starts_at = self.starts_at_was
      self.ends_at = self.ends_at_was
      self.url = self.url_was
    end
  end

end
