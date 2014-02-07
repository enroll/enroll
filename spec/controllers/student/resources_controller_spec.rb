require "spec_helper"

describe Student::ResourcesController do
  let(:student) { create(:student) }
  let(:course) { create(:course) }

  before {
    sign_in(student)
    reservation = create(:reservation, student: student, course: course)
  }

  describe "#index" do
    it "looks up all resources for course" do
      create(:resource, course: course)
      create(:resource, course: course)

      get :index, course_id: course.id
      response.should be_ok
      assigns(:resources).should_not be_nil
      assigns(:resources).length.should == 2
    end 
  end
end