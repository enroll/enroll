require 'spec_helper'

describe Reservation do
  let(:instructor)  { build(:instructor) }
  let(:course)      { build(:course, instructor: instructor) }
  let(:student)     { build(:student) }
  let(:reservation) { build(:reservation, student: student, course: course, stripe_token: 'foo') }

  it { should belong_to(:course) }
  it { should belong_to(:student) }

  it { should validate_presence_of(:course) }
  it { should validate_presence_of(:student) }

  before do
    Stripe::Customer.stubs(:create).with(anything).returns(stub(:id => 'cus_1'))
    Stripe::Charge.stubs(:create).with(anything).returns(stub())
  end

  context "#instructor" do
    it "should be the instructor of the course" do
      reservation.instructor.should == instructor
    end
  end

  context "when a reservation is made" do
    it "delivers an enrollment notification" do
      reservation.expects(:send_enrollment_notification)
      reservation.save!
    end

    it "fails if student is already enrolled for that course" do
      reservation.save!

      reservation = Reservation.new
      reservation.student = student
      reservation.course = course
      reservation.save.should == false
    end
  end

  context "#charged?" do
    it "returns true if charge succeeded at is set" do
      reservation.charge_succeeded_at = Time.now
      reservation.should be_charged
    end

    it "returns false if charge succeeded at is not set" do
      reservation.charge_succeeded_at = nil
      reservation.should_not be_charged
    end
  end

  context "#charge_amount" do
    context "paid course" do
      before { course.price_per_seat_in_cents = 5000 }

      it "saves the course's price as charge amount when reservation created" do
        reservation.charge_amount.should be_nil
        reservation.save!
        reservation.charge_amount.should == 5000
      end

      it "does not change the charge amount when course price changes" do
        reservation.save!
        course.price_per_seat_in_cents = 10000
        reservation.save!
        reservation.reload.charge_amount.should == 5000
      end
    end
  end

  context "#send_enrollment_notification" do
    before { reservation.save! }

    it "enqueues an enrollment notification job" do
      Resque.expects(:enqueue).with(EnrollmentNotification, reservation.id)
      reservation.send_enrollment_notification
    end
  end

  context "#send_enrollment_notification!" do
    it "notifies the instructor when a student enrolls" do
      InstructorMailer.expects(:student_enrolled).
        with(reservation).returns(mock 'mail', :deliver => true)

      reservation.send_enrollment_notification!
    end

    it "notifies the student that they enrolled" do
      StudentMailer.expects(:enrolled).
        with(reservation).returns(mock 'mail', :deliver => true)

      reservation.send_enrollment_notification!
    end
  end

  context "#check_campaign_success" do
    context "when minimum seats is zero" do
      before do
        course.min_seats = 0
        reservation.save!
      end

      it "does not enqueue a job" do
        Resque.expects(:enqueue).never
        reservation.check_campaign_success
      end
    end

    context "when minimum seats is greater than zero" do
      context "when reservation satisfies minimum seats" do
        before do
          course.min_seats = 1
          reservation.save!
        end

        it "enqueues a campaign success notification job" do
          Resque.stubs(:enqueue).with(ChargeCreditCards, course.id) # the other enqueue call
          Resque.expects(:enqueue).with(CampaignSuccessNotification, course.id)
          reservation.check_campaign_success
        end

        context "when workshop is free" do
          it "does not charge credit cards" do
            course.update_attribute(:price_per_seat_in_cents, 0)
            
            Resque.stubs(:enqueue).with(CampaignSuccessNotification, course.id) # the other enqueue call
            Resque.expects(:enqueue).with(ChargeCreditCards, course.id).never
            reservation.check_campaign_success
          end
        end

        context "when workshop is not free" do
          it "enqueues a charge credit cards job" do
            Resque.stubs(:enqueue).with(CampaignSuccessNotification, course.id) # the other enqueue call
            Resque.expects(:enqueue).with(ChargeCreditCards, course.id)
            reservation.check_campaign_success
          end
        end
      end

      context "when reservation is short of minimum seats" do
        before do
          course.min_seats = 2
          reservation.save!
        end

        it "does not enqueue a job" do
          Resque.expects(:enqueue).never
          reservation.check_campaign_success
        end
      end

      context "when minimum seats has already been met" do
        before do
          course.min_seats = 1
          course.save
          # Have to enroll as different student 2nd time
          other_student = create(:student)
          create(:reservation, course: course, student: other_student)
          reservation.save!
        end

        it "does not send a notification" do
          course.expects(:send_campaign_success_notifications!).never
          reservation.check_campaign_success
        end

        it "charges credit card for the reservation" do
          reservation.charged?.should be_false
          reservation.save!
          reservation.reload.charged?.should be_true
        end
      end
    end
  end

end
