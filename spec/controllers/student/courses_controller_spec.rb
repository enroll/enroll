require "spec_helper"

describe Student::CoursesController do
  let(:student) { create(:student) }
  let(:course) { create(:course) }

  before(:each) do
    sign_in(student)
    reservation = create(:reservation, student: student, course: course)
  end

  describe "#index" do
    it "finds student's course" do
      get :show, id: course.id
      response.should_not redirect_to(root_path)
      response.should be_ok
      assigns(:course).should == course
    end

    it "redirects to home if student doesn't own the course" do
      get :show, id: create(:course).id
      response.should redirect_to(root_path)
    end
  end
end