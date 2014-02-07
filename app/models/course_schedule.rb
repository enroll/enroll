class CourseSchedule < ActiveRecord::Base
  belongs_to :course, inverse_of: :schedules

  validates :course_id, presence: true
  validates :date, presence: true
  # validates :starts_at, presence: true
  # validates :ends_at, presence: true

  TIME_FORMAT = "%I:%M%p"

  def as_json(options = {})
    {
      identifier: date,
      label: date,
      starts_at: starts_at,
      ends_at: ends_at
    }
  end

  def starts_at
    midnight_seconds_to_str(self[:starts_at])
  end

  def starts_at=(value)
    self[:starts_at] = str_to_midnight_seconds(value)
  end

  def starts_at_time
    Time.parse(date.to_s + " " + starts_at)
  end

  def ends_at
    midnight_seconds_to_str(self[:ends_at])
  end

  def ends_at=(value)
    self[:ends_at] = str_to_midnight_seconds(value)
  end

  def ends_at_time
    Time.parse(date.to_s + " " + ends_at)
  end

  def range_str
    if starts_at && ends_at
      "#{starts_at} - #{ends_at}"
    elsif starts_at
      "starting #{starts_at}"
    elsif ends_at
      "ends #{ends_at}"
    end
  end

  protected

  def str_to_midnight_seconds(str)
    return nil unless str.present?
    time = Time.strptime(str, TIME_FORMAT)
    time.seconds_since_midnight
  end

  def midnight_seconds_to_str(seconds)
    return nil unless seconds
    time = Time.now.midnight + seconds.seconds
    time.strftime(TIME_FORMAT).downcase
  end
end