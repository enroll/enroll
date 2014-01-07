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
    [name, city_and_state].select(&:present?).join(", ")
  end

  def city_and_state
    [city, state].select(&:present?).join(", ")
  end

  def city_and_zip_and_state
    [city, zip_and_state].select(&:present?).join(", ")
  end

  def zip_and_state
    [zip, state].select(&:present?).join(" ")
  end

  def address_1_and_2
    [address, address_2].select(&:present?).join(", ")
  end

  def to_full_s
    s = []

    s << "<strong>#{name}</strong>" if name.present?
    s << address_1_and_2 if address_1_and_2.present?
    s << city_and_zip_and_state if city_and_zip_and_state.present?

    s.join("<br />").html_safe
  end
end
