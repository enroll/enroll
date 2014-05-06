require 'spec_helper'

describe StudentMailer do
  let(:instructor)  { build(:instructor, :email => "instructor@example.com") }
  let(:course)      { build(:course, instructor: instructor, name: "Hackers 101", url: nil) }
  let(:student)     { build(:student, :email => "student@example.com") }
  let(:reservation) { build(:reservation, student: student, course: course) }

  describe "#campaign_failed" do
    let(:email) { StudentMailer.campaign_failed(course, student) }

    it "delivers the campaign failure notification" do
      email.should deliver_to("student@example.com")
      email.should deliver_from("Enroll <noreply@enroll.io>")
      email.should have_subject(/Hackers 101/)
    end
  end

  describe "#campaign_succeeded" do
    let(:email) { StudentMailer.campaign_succeeded(course, student) }

    it "delivers the campaign success notification" do
      email.should deliver_to("student@example.com")
      email.should deliver_from("Enroll <noreply@enroll.io>")
      email.should have_subject(/Hackers 101/)
    end
  end

  describe "#campaign_ending_soon" do
    let(:email) { StudentMailer.campaign_ending_soon(course, student) }

    it "delivers the campaign ending soon reminder" do
      email.should deliver_to("student@example.com")
      email.should deliver_from("Enroll <noreply@enroll.io>")
      email.should have_subject(/Hackers 101/)
    end
  end

  describe "#enrolled" do
    let(:email) { StudentMailer.enrolled(reservation) }

    it "delivers the enrollment notification" do
      email.should deliver_to("student@example.com")
      email.should deliver_from("Enroll <noreply@enroll.io>")
      email.should have_subject(/Hackers 101/)
    end
  end
end
