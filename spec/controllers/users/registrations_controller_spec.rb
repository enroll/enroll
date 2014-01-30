require 'spec_helper'

describe Users::RegistrationsController do
  include Devise::TestHelpers
  render_views

  before do
    setup_controller_for_warden
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:user_attributes) { attributes_for(:user).merge({ course: attributes_for(:course)}) }

  context "POST users" do
    context "with valid params" do
      it "creates a new user" do
        expect {
          post :create, user: user_attributes
        }.to change(User, :count)
      end

      it "creates a new course" do
        expect {
          post :create, user: user_attributes
        }.to change(Course, :count)
      end

      it "associates the course and the user" do 
        post :create, user: user_attributes
        Course.last.instructor.should == User.last
      end

      it "redirects to the manage course page" do
        post :create, user: user_attributes
        response.should be_redirect
        response.should redirect_to(edit_course_path(Course.last))
      end
    end

    context "with invalid params" do
      before { Course.any_instance.stubs(:save).returns(false) }

      it "assigns a newly created but unsaved user as @user" do
        post :create, user: user_attributes
        assigns(:user).should be_instance_of(User)
      end

      it "assigns a newly created but unsaved course as @course" do
        post :create, user: user_attributes
        assigns(:course).should be_instance_of(Course)
      end
    end
  end

end
