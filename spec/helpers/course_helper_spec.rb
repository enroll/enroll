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

    it "returns question mark if min seats is not set" do
      course = create(:course, min_seats: nil)
      reservations_needed(course).should == "?"
    end
  end

  context "#days_until_start" do
    it "returns the number of days until the course starts if it's in the future" do
      current_time = "2013-08-01 12:00:00 UTC"
      starts_at    = "2013-08-21 12:00:00 UTC"

      Timecop.freeze(current_time) do
        course = build(:course, starts_at: starts_at)
        days_until_start(course).should == 20
      end
    end

    it "returns zero if it's in the past" do
      course = build(:course, starts_at: 20.days.ago)
      days_until_start(course).should == 0
    end

    it "returns zero if it's today" do
      course = build(:course, starts_at: Date.today)
      days_until_start(course).should == 0
    end

    it "returns question mark if starts_at is not set" do
      course = build(:course, starts_at: nil)
      days_until_start(course).should == "?"
    end
  end

  context "#percentage_to_full" do
    it "returns the percentage of reservations to max seats" do
      course = create(:course, max_seats: 20)
      5.times { create(:reservation, course: course) }
      percentage_to_full(course).should == 25
    end

    it "returns zero if max seats is not set" do
      course = create(:course, max_seats: nil)
      percentage_to_full(course).should == 0
    end
  end

  context "#percentage_goal" do
    it "returns the percentage of min seats to max seats" do
      course = build(:course, min_seats: 10, max_seats: 20)
      percentage_goal(course).should == 50
    end

    it "returns zero if max seats is not set" do
      course = build(:course, max_seats: nil)
      percentage_goal(course).should == 0
    end

    it "returns zero if min seats is not set" do
      course = build(:course, min_seats: nil)
      percentage_goal(course).should == 0
    end
  end

  context "#course_reservation_link" do
    it "returns a link to the course reservation page" do
      course = create(:course)

      price = number_to_currency(price_in_dollars(course.price_per_seat_in_cents))
      link = link_to "Enroll - #{price}",
        new_course_reservation_path(course),
        :class => 'btn btn-primary btn-large reserve'

      course_reservation_link(course).should == link
    end
  end

  context "#facebook_og_meta_tags" do
    let(:course) { build(:course) }
    it "returns an og title with course title" do
      course.name = "My course"
      facebook_og_meta_tags(course).should =~ /meta property="og:title" content="My course"/
    end

    it "returns an og description with course tagline" do
      course.tagline = "The best course EVAR!!!"
      facebook_og_meta_tags(course).should =~ /meta property="og:description" content="The best course EVAR!!!"/
    end

    it "returns an og url with course short url" do
      course.url = "best-course-evar"
      facebook_og_meta_tags(course).should =~ /meta property="og:url" content=".*\/go\/best-course-evar"/
    end

    it "returns an og image with enroll logo" do
      facebook_og_meta_tags(course).should =~ /meta property="og:image" content=".*\/assets\/images\/enroll-io-logo.png"/
    end
  end
end
