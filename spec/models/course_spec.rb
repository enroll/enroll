require 'spec_helper'

describe Course do
  let(:course) { build(:course) }

  it { should belong_to(:location) }
  it { should belong_to(:instructor) }
  it { should have_many(:reservations) }
  it { should have_many(:students) }

  it { should validate_presence_of(:name) }

  describe "#url" do
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

  describe "#url_or_short_name" do
    it "shortens the course name to 20 characters when there is no url" do
      course.name = "Introduction to Ruby on Rails"
      course.url = nil
      course.url_or_short_name.should == "Introduction to Ruby"
    end

    it "returns url when there is a url" do
      course.name = "Introduction to Ruby on Rails"
      course.url = "intro-to-rails"
      course.url_or_short_name.should == "intro-to-rails"
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
        course.min_seats = 2
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

  describe "#send_campaign_failed_notifications!" do
    before do
      course.save
      create(:reservation, course: course)
    end

    it "notifies the instructor when the campaign fails" do
      InstructorMailer.expects(:campaign_failed).
        with(course).returns(mock 'mail', :deliver => true)

      course.send_campaign_failed_notifications!
    end

    it "notifies the student when the campaign fails" do
      student = course.students.first
      StudentMailer.expects(:campaign_failed).
        with(course, student).returns(mock 'mail', :deliver => true)

      course.send_campaign_failed_notifications!
    end
  end

  describe "#send_campaign_ending_soon_notifications!" do
    before do
      course.save
      create(:reservation, course: course)
    end

    it "notifies the student when the campaign fails" do
      student = course.students.first
      StudentMailer.expects(:campaign_ending_soon).
        with(course, student).returns(mock 'mail', :deliver => true)

      course.send_campaign_ending_soon_notifications!
    end
  end

  describe ".notify_ending_soon_campaigns" do
    context "when the campaign is under 48 hours from ending" do
      context "and minimums are met" do
        before do
          course.campaign_ends_at = 1.day.from_now
          course.min_seats = 1
          course.save
          2.times { create(:reservation, course: course) }
        end

        it "does not notify students" do
          Resque.expects(:enqueue).never
          Course.notify_ending_soon_campaigns
        end

        it "sets the course as having been reminded" do
          Course.notify_ending_soon_campaigns
          course.reload.campaign_ending_soon_reminded_at.should be_nil
        end
      end

      context "and minimums are not met" do
        before do
          course.campaign_ends_at = 1.day.from_now
          course.campaign_ending_soon_reminded_at = nil
          course.min_seats = 2
          course.save
          create(:reservation, course: course)
        end

        it "notifies students that the end is nigh" do
          Resque.expects(:enqueue).with(CampaignEndingSoonNotification, course.id)
          Course.notify_ending_soon_campaigns
        end

        it "sets the course as having been reminded" do
          Course.notify_ending_soon_campaigns
          course.reload.campaign_ending_soon_reminded_at.should_not be_nil
        end
      end

      context "and campaign has already been reminded" do
        before do
          course.campaign_ends_at = 1.day.from_now
          course.min_seats = 2
          course.campaign_ending_soon_reminded_at = Time.now
          course.save
          create(:reservation, course: course)
        end

        it "does not notify students" do
          Resque.expects(:enqueue).never
          Course.notify_ending_soon_campaigns
        end
      end
    end
  end

  describe "#charge_credit_cards!", :vcr do
    before do
      course.price_per_seat_in_cents = 1000
      course.save

      @user = create(:student, email: 'stripe-student@example.com')

      @stripe_token = Stripe::Token.create(
          :card => {
          :number => "4242424242424242",
          :exp_month => 10,
          :exp_year => 2014,
          :cvc => "314"
        },
      )
      @reservation = course.reservations.create(
        student: @user, 
        stripe_token: @stripe_token.id
      )
    end

    context "when user doesn't have a stripe customer" do
      before do
        Stripe::Charge.stubs(:create)
      end

      it "creates a customer" do
        Stripe::Customer.expects(:create)
                        .with(card: @stripe_token.id, 
                              description: 'stripe-student@example.com')
                        .returns(stub(id: 1))
        course.charge_credit_cards!
      end

      it "associates the customer with the user" do
        Stripe::Customer.stubs(:create).returns(stub(id: 1))
        course.charge_credit_cards!
        @user.stripe_customer_id.should == 1
      end
    end

    context "when user has a stripe customer" do
      before do
        customer = Stripe::Customer.create(card: @stripe_token.id)
        @user.update_attribute(:stripe_customer_id, customer.id)
      end 

      it "does not create a customer" do
        Stripe::Customer.expects(:create).never
      end
    end

    context "when the reservation has not been charged" do
      before { @reservation.update_attribute(:charge_succeeded_at, nil) }

      it "charges the customer" do
        Stripe::Charge.expects(:create).with(has_entries(amount: 1000,
                                                         currency: 'usd'))
        course.charge_credit_cards!
      end

      context "when charge succeeds" do
        it "updates the reservation with the charged date" do
          course.charge_credit_cards!
          @reservation.charge_succeeded_at.should_not be_nil
        end

        it "clears the token" do
          course.charge_credit_cards!
          @reservation.stripe_token.should be_nil
        end
      end

      context "when charge fails" do
        let(:exception) { Stripe::CardError.new("Card declined", "param", "code") }

        it "updates the reservation with the charge error" do
          Stripe::Charge.expects(:create).raises(exception)

          course.charge_credit_cards!
          @reservation.charge_failure_message.should == "Card declined"
        end

        it "charges other reservations" do
          @user.update_attribute(:stripe_customer_id, 1)
          user_two = create(:student, stripe_customer_id: 2)
          course.reservations.create(student: user_two)

          Stripe::Charge.expects(:create)
                        .with(has_entry(customer: 1))
                        .raises(exception)
          Stripe::Charge.expects(:create)
                        .with(has_entry(customer: 2))

          course.charge_credit_cards!
        end
      end

      context "when there is no token and no stripe customer" do
        before do
          @reservation.update_attributes(
            charge_succeeded_at: nil,
            stripe_token: nil
          )
          @user.update_attribute(:stripe_customer_id, nil)
        end

        it "logs an error message" do
          Raven.expects(:capture_message)
          course.charge_credit_cards!
        end

        it "doesn't create a customer" do
          Stripe::Customer.expects(:create).never
          course.charge_credit_cards!
        end
      end
    end

    context "when the reservation has been charged" do
      it "does not charge the customer" do
        @reservation.update_attribute(:charge_succeeded_at, Time.now)

        Stripe::Charge.expects(:create).never

        course.charge_credit_cards!
      end
    end

    it "charges the amount on the reservation even if it differs from course" do
      @reservation.charge_amount = 2000
      Stripe::Charge.expects(:create).with(has_entries(amount: 2000,
                                                       currency: 'usd'))
      course.charge_credit_cards!
    end

    it "does not charge when the course is free" do
      course.update_attribute(:price_per_seat_in_cents, 0)
      Stripe::Charge.expects(:create).never
      Stripe::Customer.expects(:create).never
    end
  end

  describe "#start_date" do
    it "returns a date value" do
      course.starts_at = Time.parse("January 1 2014 12:01 PM EST")
      course.start_date.should == "Wed, January  1, 2014"
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

    it "changes attribute to blank value" do
      course.location_attributes = { name: 'Test', address: '' }
      course.location.address.should == ''
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

  describe "#send_campaign_success_notifications!" do
    before do
      course.save
      create(:reservation, course: course)
    end

    it "notifies the instructor when the course has met minimum enrollment" do
      InstructorMailer.expects(:campaign_succeeded).
        with(course).returns(mock 'mail', :deliver => true)

      course.send_campaign_success_notifications!
    end

    it "notifies the students when the course has met minimum enrollment" do
      student = course.students.first
      StudentMailer.expects(:campaign_succeeded).
        with(course, student).returns(mock 'mail', :deliver => true)

      course.send_campaign_success_notifications!
    end
  end

  describe "#future?" do
    it "returns true if course start date is in the future" do
      course.starts_at = Time.now + 1.hour
      course.should be_future
    end

    it "returns false if course start date is in the past" do
      course.starts_at = Time.now - 1.hour
      course.should_not be_future
    end
  end

  describe "#campaign_failed?" do
    it "returns true if campaign failed at is not nil" do
      course.campaign_failed_at = Time.now - 1.hour
      course.should be_campaign_failed
    end

    it "returns false if campaign failed at is nil" do
      course.campaign_failed_at = nil
      course.should_not be_campaign_failed
    end
  end

  describe "#send_course_created_notification" do
    it "queues a course created notification when course is created" do
      Resque.expects(:enqueue).with(CourseCreatedNotification, kind_of(Integer))
      create(:course)
    end

    it "does not queue a course created notification when existing course is saved" do
      course.save
      Resque.expects(:enqueue).never
      course.save
    end
  end

  describe "#send_course_created_notification!" do
    it "notifies the admins that a course has been created" do
      AdminMailer.expects(:course_created).
        with(course).returns(mock 'mail', :deliver => true)

      course.send_course_created_notification!
    end
  end

  describe "#pay_instructor!" do
    before do
      course.instructor.stripe_recipient_id = "asdf1234"
      course.name = "Some course name"
      course.starts_at = course.ends_at = 1.day.ago
      course.save
    end

    it "creates a Stripe payout" do
      CashRegister.expects(:instructor_payout_amount).with(course).returns(50123)
      Payout.expects(:create).with({
        amount_in_cents: 50123,
        description: "Some course name",
        stripe_recipient_id: "asdf1234"
      }).returns(stub 'payout', :request => true)

      course.pay_instructor!
    end

    context "payout initiates successfully" do
      before { Payout.stubs(:create).returns(stub 'payout', :request => true) }

      it "returns true" do
        course.pay_instructor!.should be_true
      end

      it "sets instructor_paid_at" do
        course.pay_instructor!
        course.reload.instructor_paid_at.should_not be_nil
      end
    end

    context "payout did NOT initiate successfully" do
      before { Payout.stubs(:create).returns(stub 'payout', :request => false) }

      it "returns false" do
        course.pay_instructor!.should be_false
      end

      it "does not set instructor_paid_at" do
        course.pay_instructor!
        course.reload.instructor_paid_at.should be_nil
      end
    end

    it "returns false if course has not happened yet" do
      Payout.stubs(:create).returns(stub 'payout', :request => true)
      course.ends_at = course.starts_at = 1.day.from_now

      course.pay_instructor!.should be_false
    end

    it "returns false if course is free" do
      Payout.stubs(:create).returns(stub 'payout', :request => true)
      course.price_per_seat_in_cents = nil

      course.pay_instructor!.should be_false
    end

    it "returns false if course has already been paid" do
      Payout.stubs(:create).returns(stub 'payout', :request => true)
      course.instructor_paid_at = 1.day.ago

      course.pay_instructor!.should be_false
    end
  end

  describe "#price_per_seat_in_dollars" do
    it 'does not fail when there is no price set' do
      course.price_per_seat_in_cents = nil
      course.price_per_seat_in_dollars.should == nil
    end
  end

  describe "#price_per_seat_in_dollars=" do
    it 'sets price in dollars as string' do
      course.price_per_seat_in_dollars = '20'
      course.price_per_seat_in_cents.should == 2000
    end
  end

  describe "#schedules_attributes=" do
    it "preserves schedules between saves" do
      course.save! # only works on a saved course
      course.schedules_attributes = [{date: '2013-12-31', starts_at: '9:00am'}]
      course.save!
      course.schedules.count.should == 1
      course.save!
      course.schedules.count.should == 1
    end
  end

  describe "#as_json" do
    it "returns nil for date if date is nil" do
      course.starts_at = nil
      course.as_json[:starts_at].should == nil
    end
  end

  describe "#publish!" do
    it "publishes the course" do
      course.published?.should == false
      course.publish!
      course.reload.published?.should == true
    end
  end
end
