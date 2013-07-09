require 'spec_helper'

describe Course do
  let(:course) { build(:course) }
  let(:location) { build(:location)}
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

  it "belongs to a location" do
    course.location = location
    course.location.must_equal location
  end

  describe "course_start_date" do
    it "returns a date value" do
      course.course_starts_at = Time.parse("January 1 2014 12:01 PM EST")
      course.course_start_date.must_equal "Wed, January  1 2014"
    end
  end

  describe "course_start_time" do
    it "returns a time value" do
      course.course_starts_at = Time.parse("January 1 2014 12:01 PM EST")
      course.course_start_time.must_equal " 5:01 PM UTC"
    end
  end

  describe "course_end_time" do
    it "returns a time value" do
      course.course_ends_at = Time.parse("January 1 2014 4:01 PM EST")
      course.course_end_time.must_equal " 9:01 PM UTC"
    end
  end

  context "#reservations" do
    before { course.save! }

    it "has many reservations" do
      course.reservations.create!(reservation_attributes)
      course.reservations.count.must_equal 1
    end
  end

  describe "location_attributes" do
    before { course.location = nil }

    it "creates a location" do
      assert_difference "Location.count" do
        course.location_attributes = { name: 'New Location' }
        course.location.wont_equal nil
        course.location.name.must_equal 'New Location'
      end
    end

    it "matches an existing location" do
      location = create(:location, name: 'Existing Location')
      assert_no_difference "Location.count" do
        course.location_attributes = { name: 'Existing Location' }
        course.location.name.must_equal 'Existing Location'
      end
    end

    it "only creates a location if attrs are present" do
      course.location_attributes = { name: '', address: '' }
      course.location.must_equal nil
    end
  end
end
