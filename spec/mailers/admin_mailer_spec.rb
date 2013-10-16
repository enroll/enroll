require 'spec_helper'

describe AdminMailer do
  let(:instructor)  { build(:instructor, :email => "instructor@example.com") }
  let(:course)      { build(:course, instructor: instructor, name: "Hackers 101") }

  describe "#course_created" do
    let(:email) { AdminMailer.course_created(course) }

    it "delivers the campaign succeeded notification" do
      email.should deliver_to("support@enroll.io")
      email.should deliver_from("Enroll <help@enroll.io>")
      email.should have_subject(/Hackers 101/)
    end
  end
end
