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
end
