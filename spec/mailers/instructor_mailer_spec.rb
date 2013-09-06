require 'spec_helper'

describe InstructorMailer do
  let(:instructor)  { build(:instructor, :email => "instructor@example.com") }
  let(:course)      { build(:course, instructor: instructor, name: "Hackers 101") }
  let(:student)     { build(:student, :email => "student@example.com") }
  let(:reservation) { build(:reservation, student: student, course: course) }

  describe "#student_enrolled" do
    let(:email) { InstructorMailer.student_enrolled(reservation) }

    it "delivers the enrollment notification" do
      email.should deliver_to("instructor@example.com")
      email.should deliver_from("Enroll <noreply@enroll.io>")
      email.should have_subject("[Hackers 101] A new student has enrolled")
    end
  end

  describe "#campaign_failed" do
    let(:email) { InstructorMailer.campaign_failed(course) }

    it "delivers the campaign failed notification" do
      email.should deliver_to("instructor@example.com")
      email.should deliver_from("Enroll <help@enroll.io>")
      email.should have_subject("[Hackers 101] Course didn't meet reach your minimum reservations")
    end
  end

  describe "#campaign_succeeded" do
    let(:email) { InstructorMailer.campaign_succeeded(course) }

    it "delivers the campaign succeeded notification" do
      email.should deliver_to("instructor@example.com")
      email.should deliver_from("Enroll <help@enroll.io>")
      email.should have_subject("[Hackers 101] Congrats! Your course has met your minimums.")
    end
  end
end
