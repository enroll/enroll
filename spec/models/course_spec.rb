require 'spec_helper'

describe Course do
  let(:course) { build(:course) }
  let(:reservation) { build(:reservation) }
  let(:reservation_attributes) { attributes_for :reservation }

  it "has a name" do
    course.name = "Cow Tipping 101"
    course.name.must_equal "Cow Tipping 101"
  end

  it "requires a name" do
    course.name = nil
    course.valid?
    course.errors[:name].must_include "can't be blank"
  end

  context "#reservations" do
    before { course.save! }

    it "has many reservations" do
      course.reservations.create!(reservation_attributes)
      course.reservations.count.must_equal 1
    end
  end
end
