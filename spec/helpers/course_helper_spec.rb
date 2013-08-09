require 'spec_helper'

describe CourseHelper do
  context "#reservations_needed" do
    it "returns zero if there are more reservations than the minimum number of seats" do
      course = create(:course, min_seats: 2)
      3.times { create(:reservation, course: course) }
      reservations_needed(course).should == 0
    end

    it "returns the minimum number of seats minus the number of reservations" do
      course = create(:course, min_seats: 10)
      3.times { create(:reservation, course: course) }
      reservations_needed(course).should == 7
    end

    it "returns question mark if min_seats is not set" do
      course = create(:course, min_seats: nil)
      reservations_needed(course).should == "?"
    end
  end

  context "#days_until_start" do
    it "returns the number of days until the course starts if it's in the future" do
      course = create(:course, starts_at: 20.days.from_now)
      days_until_start(course).should == 20
    end

    it "returns zero if it's in the past" do
      course = create(:course, starts_at: 20.days.ago)
      days_until_start(course).should == 0
    end

    it "returns zero if it's today" do
      course = create(:course, starts_at: Date.today)
      days_until_start(course).should == 0
    end

    it "returns question mark if starts_at is not set" do
      course = create(:course, starts_at: nil)
      days_until_start(course).should == "?"
    end
  end
end
