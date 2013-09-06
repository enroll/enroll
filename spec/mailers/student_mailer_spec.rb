require 'spec_helper'

describe StudentMailer do
  let(:instructor)  { build(:instructor, :email => "instructor@example.com") }
  let(:course)      { build(:course, instructor: instructor, name: "Hackers 101") }
  let(:student)     { build(:student, :email => "student@example.com") }
  let(:reservation) { build(:reservation, student: student, course: course) }

  describe "#campaign_failed" do
    let(:email) { StudentMailer.campaign_failed(course, student) }

    it "delivers the campaign failure notification" do
      email.should deliver_to("student@example.com")
      email.should deliver_from("Enroll <noreply@enroll.io>")
      email.should have_subject("[Hackers 101] Course didn't reach minimum reservations")
    end
  end
end
