class Location < ActiveRecord::Base
  has_many :courses, dependent: :destroy

  validates :name, presence: true

  def as_json(options = {})
    {
      name: name,
      address: address,
      city: city,
      state: state
    }
  end

  def to_s
    s = name
    if state.present? && city.present?
      s += ", #{city}, #{state}"
    elsif state.present?
      s += ", #{state}"
    elsif city.present?
      s += ", #{city}"
    end
    s
  end

  def to_full_s
    "<strong>#{name}</strong><br/>#{address}, #{city}<br />#{zip} #{state}".html_safe
  end
end
