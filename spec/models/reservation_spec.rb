require 'spec_helper'

describe Reservation do
  let(:instructor)  { build(:instructor) }
  let(:course)      { build(:course, instructor: instructor) }
  let(:student)     { build(:student) }
  let(:reservation) { build(:reservation, student: student, course: course) }

  it { should belong_to(:course) }
  it { should belong_to(:student) }

  it { should validate_presence_of(:course) }
  it { should validate_presence_of(:student) }

  context "#instructor" do
    it "should be the instructor of the course" do
      reservation.instructor.should == instructor
    end
  end

  context "when a reservation is made" do
    it "delivers an enrollment notification" do
      reservation.expects(:send_enrollment_notification)
      reservation.save
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

  context "#send_enrollment_notification" do
    before { reservation.save }

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
  end

  context "#check_campaign_success" do
    context "when minimum seats is zero" do
      before do
        course.min_seats = 0
        reservation.save
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
          reservation.save
        end

        it "enqueues a campaign success notification job" do
          Resque.expects(:enqueue) # the other enque call
          Resque.expects(:enqueue).with(CampaignSuccessNotification, course.id)
          reservation.check_campaign_success
        end

        context "when workshop is free" do
          it "does not charge credit cards" do
            course.update_attribute(:price_per_seat_in_cents, 0)
            
            Resque.expects(:enqueue) # the other enque call
            Resque.expects(:enqueue).with(ChargeCreditCards, course.id).never
            reservation.check_campaign_success
          end
        end

        context "when workshop is not free" do
          it "enqueues a charge credit cards job" do
            Resque.expects(:enqueue) # the other enque call
            Resque.expects(:enqueue).with(ChargeCreditCards, course.id)
            reservation.check_campaign_success
          end
        end
      end

      context "when reservation is short of minimum seats" do
        before do
          course.min_seats = 2
          reservation.save
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
          create(:reservation, course: course)
          reservation.save
        end

        it "does not enqueue a job" do
          Resque.expects(:enqueue).never
          reservation.check_campaign_success
        end
      end
    end
  end

end
