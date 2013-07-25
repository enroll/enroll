require 'spec_helper'

describe Course do
  let(:course) { build(:course) }

  it { should belong_to(:location) }
  it { should belong_to(:instructor) }
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
      create(:location, name: 'Existing Location')
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

  describe ".future" do
    it "returns a course in the future" do
      course = create(:course, course_starts_at: Date.tomorrow)
      Course.future.should include(course)
    end

    it "does not return a course in the past" do
      course = create(:course, course_starts_at: Date.yesterday)
      Course.future.should_not include(course)
    end

    it "returns a course that is today" do
      course = create(:course, course_starts_at: Date.today)
      Course.future.should include(course)
    end

    it "returns courses sorted with sooner courses first" do
      later_course = create(:course, course_starts_at: Date.tomorrow+1)
      next_course = create(:course, course_starts_at: Date.tomorrow)

      Course.future.should == [next_course, later_course]
    end
  end

  describe ".past" do
    it "returns a course in the past" do
      course = create(:course, course_starts_at: Date.yesterday)
      Course.past.should include(course)
    end

    it "does not return a course in the future" do
      course = create(:course, course_starts_at: Date.tomorrow)
      Course.past.should_not include(course)
    end

    it "does not return a course that is today" do
      course = create(:course, course_starts_at: Date.today)
      Course.past.should_not include(course)
    end

    it "returns courses sorted with most recent courses first" do
      long_ago_course = create(:course, course_starts_at: Date.yesterday-10)
      recent_course = create(:course, course_starts_at: Date.yesterday)

      Course.past.should == [recent_course, long_ago_course]
    end
  end

  describe ".without_dates" do
    it "returns a course without a date" do
      course = create(:course, course_starts_at: nil)
      Course.without_dates.should include(course)
    end

    it "does not return a course with a date" do
      course = create(:course, course_starts_at: Date.today)
      Course.without_dates.should_not include(course)
    end
  end
end
