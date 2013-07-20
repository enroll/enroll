require 'spec_helper'

describe Instructors::RegistrationsController do
  include Devise::TestHelpers
  render_views

  before do
    setup_controller_for_warden
    request.env["devise.mapping"] = Devise.mappings[:instructor]
  end

  let(:instructor_attributes) { attributes_for(:instructor).merge({ course: attributes_for(:course)}) }
  
  context "POST instructors" do
    context "with valid params" do
      it "creates a new instructor" do
        expect {
          post :create, instructor: instructor_attributes
        }.to change(Instructor, :count)
      end

      it "creates a new course" do
        expect {
          post :create, instructor: instructor_attributes
        }.to change(Course, :count)
      end

      it "associates the course and the instructor" do 
        post :create, instructor: instructor_attributes
        Course.last.instructor.should == Instructor.last
      end

      it "redirects to the manage course page" do
        post :create, instructor: instructor_attributes
        response.should be_redirect
        response.should redirect_to(edit_course_path(Course.last))
      end
    end

    context "with invalid params" do
      before { Course.any_instance.stubs(:save).returns(false) }

      it "assigns a newly created but unsaved instructor as @instructor" do
        post :create, instructor: instructor_attributes
        assigns(:instructor).should be_instance_of(Instructor)
      end

      it "assigns a newly created but unsaved course as @course" do
        post :create, instructor: instructor_attributes
        assigns(:course).should be_instance_of(Course)
      end

      it "re-renders the root page" do
        post :create, instructor: instructor_attributes
        response.should render_template(:index)
      end

      it "sets the error flash" do
        post :create, instructor: instructor_attributes
        flash[:error].should_not be_nil
      end
    end
  end

end
