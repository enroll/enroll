require 'spec_helper'

describe Course do
  let(:course) { build(:course) }

  it { should belong_to(:location) }
  it { should have_many(:reservations) }

  it { should validate_presence_of(:name) }

  describe "course_start_date" do
    it "returns a date value" do
      course.course_starts_at = Time.parse("January 1 2014 12:01 PM EST")
      course.course_start_date.should == "Wed, January  1 2014"
    end
  end

  describe "course_start_time" do
    it "returns a time value" do
      course.course_starts_at = Time.parse("January 1 2014 12:01 PM EST")
      course.course_start_time.should == " 5:01 PM UTC"
    end
  end

  describe "course_end_time" do
    it "returns a time value" do
      course.course_ends_at = Time.parse("January 1 2014 4:01 PM EST")
      course.course_end_time.should == " 9:01 PM UTC"
    end
  end

  describe "location_attributes" do
    before { course.location = nil }

    it "creates a location" do
      expect {
        course.location_attributes = { name: 'New Location' }
        course.location.should_not be_nil
        course.location.name.should == 'New Location'
      }.to change(Location, :count)
    end

    it "matches an existing location" do
      location = create(:location, name: 'Existing Location')
      expect {
        course.location_attributes = { name: 'Existing Location' }
        course.location.name.should == 'Existing Location'
      }.to_not change(Location, :count)
    end

    it "only creates a location if attrs are present" do
      expect {
        course.location_attributes = { name: '', address: '' }
        course.location.should be_nil
      }.to_not change(Location, :count)
    end
  end
end
