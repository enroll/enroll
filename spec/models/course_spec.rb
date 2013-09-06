require 'spec_helper'

describe Course do
  let(:course) { build(:course) }

  it { should belong_to(:location) }
  it { should belong_to(:instructor) }
  it { should have_many(:reservations) }
  it { should have_many(:students) }

  it { should validate_presence_of(:name) }

  describe ".url" do
    before(:each) do
      course.save
    end

    context "when editing a saved resource url directly" do
      it "only allows valid subdomain characters" do
        course.url = 'fap fap fap'
        course.should_not be_valid
        course.errors[:url].should include('is not a valid URL')
      end

      it "must be unique" do
        new_course = create(:course)
        new_course.url = course.url
        new_course.should_not be_valid
        new_course.errors[:url].should include("has already been taken")
      end
    end
  end

  describe ".fail_campaigns" do
    context "when a course does not have the minimum reservations after the campaign end date" do
      before do
        course.campaign_ends_at = 1.day.ago
        course.min_seats = 2
        course.save
        create(:reservation, course: course)
      end

      it "sends email notifications" do
        Resque.expects(:enqueue).with(CampaignFailedNotification, course.id)
        Course.fail_campaigns
      end

      it "marks the campaign as failed" do
        Course.fail_campaigns
        course.reload.campaign_failed_at.should_not be_nil
      end
    end

    context "when a course has the minimum reservations after the campaign end date" do
      before do
        course.campaign_ends_at = 1.day.ago
        course.min_seats = 1
        course.save
        2.times { create(:reservation, course: course) }
      end

      it "does not send email notifications" do
        Resque.expects(:enqueue).never
        Course.fail_campaigns
      end

      it "does not mark the campaign as failed" do
        Course.fail_campaigns
        course.reload.campaign_failed_at.should be_nil
      end
    end

    context "when the campaign end date has not arrived" do
      before do
        course.campaign_ends_at = 1.day.from_now
        course.min_seats = 1
        course.save
        create(:reservation, course: course)
      end

      it "does not email" do
        Resque.expects(:enqueue).never
        Course.fail_campaigns
      end

      it "does not mark the campaign as failed" do
        Course.fail_campaigns
        course.reload.campaign_failed_at.should be_nil
      end
    end
  end

  describe "send_campaign_failed_notifications!" do
    it "notifies the instructor when the campaign fails" do
      InstructorMailer.expects(:campaign_failed).
        with(course).returns(mock 'mail', :deliver => true)

      course.send_campaign_failed_notifications!
    end
  end

  describe "start_date" do
    it "returns a date value" do
      course.starts_at = Time.parse("January 1 2014 12:01 PM EST")
      course.start_date.should == "Wed, January  1 2014"
    end

    it "returns nil if a start date isn't set" do
      course.starts_at = nil
      course.start_date.should be_nil
    end
  end

  describe "#start_time" do
    it "returns a time value" do
      course.starts_at = Time.parse("January 1 2014 12:01 PM EST")
      course.start_time.should == " 5:01 PM UTC"
    end

    it "returns nil if the start date isn't set" do
      course.starts_at = nil
      course.start_time.should be_nil
    end
  end

  describe "#end_time" do
    it "returns a time value" do
      course.ends_at = Time.parse("January 1 2014 4:01 PM EST")
      course.end_time.should == " 9:01 PM UTC"
    end

    it "returns nil if the end date isn't set" do
      course.ends_at = nil
      course.end_time.should be_nil
    end
  end

  describe "#location_attributes=" do
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
      course = create(:course, starts_at: Time.now + 1.day)
      Course.future.should include(course)
    end

    it "does not return a course in the past" do
      course = create(:course, starts_at: Time.now - 1.day)
      Course.future.should_not include(course)
    end

    it "returns a course that is today" do
      course = create(:course, starts_at: Time.now + 1.hour)
      Course.future.should include(course)
    end

    it "returns courses sorted with sooner courses first" do
      later_course = create(:course, starts_at: Time.now + 1.day)
      next_course = create(:course, starts_at: Time.now + 1.hour)

      Course.future.should == [next_course, later_course]
    end
  end

  describe ".past" do
    it "returns a course in the past" do
      course = create(:course, starts_at: Time.now - 1.day)
      Course.past.should include(course)
    end

    it "does not return a course in the future" do
      course = create(:course, starts_at: Time.now + 1.day)
      Course.past.should_not include(course)
    end

    it "does not return a course that is today" do
      course = create(:course, starts_at: Time.now + 1.minute)
      Course.past.should_not include(course)
    end

    it "returns courses sorted with most recent courses first" do
      long_ago_course = create(:course, starts_at: Time.now - 12.hours)
      recent_course = create(:course, starts_at: Time.now - 1.hour)

      Course.past.should == [recent_course, long_ago_course]
    end
  end

  describe ".without_dates" do
    it "returns a course without a date" do
      course = create(:course, starts_at: nil)
      Course.without_dates.should include(course)
    end

    it "does not return a course with a date" do
      course = create(:course, starts_at: Time.now + 1.day)
      Course.without_dates.should_not include(course)
    end
  end

  describe "#free?" do
    it "is true if price per seat is zero" do
      course.price_per_seat_in_cents = 0
      course.should be_free
    end

    it "is false if price per seat is non-zero" do
      course.price_per_seat_in_cents = 10000
      course.should_not be_free
    end
  end

  describe "#has_students?" do
    it "returns true if course has reservations" do
      create(:reservation, course: course)
      course.has_students?.should be_true
    end

    it "returns false if course has no reservations" do
      course.has_students?.should be_false
    end
  end

end
