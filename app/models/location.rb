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
end
