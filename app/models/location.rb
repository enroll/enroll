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
      s += ", #{city}, #{city}"
    elsif state.present?
      s += ", #{state}"
    elsif city.present?
      s += ", #{city}"
    end
    s
  end
end
