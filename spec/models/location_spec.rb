require 'spec_helper'

describe Location do
  let(:location) { build(:location) }
  let(:location_attributes) { attributes_for :location }
  let(:course_attributes) { attributes_for :course }

  it "has a name" do
    location.name = "Cow Tipping Institute"
    location.name.must_equal "Cow Tipping Institute"
  end

  it "requires a name" do
    location.name = nil
    location.valid?
    location.errors[:name].must_include "can't be blank"
  end

  context "#reservations" do
    before { location.save! }

    it "has many locations" do
      location.courses.create!(course_attributes)
      location.courses.count.must_equal 1
    end
  end
end
