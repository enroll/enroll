require 'spec_helper'

describe AdminMailer do
  let(:instructor)  { build(:instructor, :email => "instructor@example.com") }
  let(:course)      { build(:course, instructor: instructor, name: "Hackers 101", url: "hackers-101") }

  describe "#course_created" do
    let(:email) { AdminMailer.course_created(course) }

    it "delivers the course created notification" do
      email.should deliver_to("Enroll Support <support@enroll.io>")
      email.should deliver_from("Enroll <help@enroll.io>")
      email.should have_subject(/\[hackers-101\]/)
    end
  end
end
