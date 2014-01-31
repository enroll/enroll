require 'spec_helper'

describe Dashboard::StudentsController do
  let(:course) { build(:course) }
  let(:user) { create(:user) }

  context "GET index" do
    before { course.save }

    context "when logged in and course belongs to instructor" do
      before do
        course.update_attribute(:instructor_id, user.id)
        sign_in(user)
      end

      it "renders the index" do
        get :index, course_id: course.id
        response.should be_success
        response.should render_template :index
      end

      it "includes the course" do
        get :index, course_id: course.id
        assigns[:course].should_not be_nil
      end
    end

    context "when logged in and course does not belong to instructor" do
      before { sign_in(user) }

      it "redirects to login" do
        get :index, course_id: course.id
        response.should be_redirect
        response.should redirect_to(new_user_session_path)
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        get :index, course_id: course.id
        response.should be_redirect
        response.should redirect_to(new_user_session_path)
      end
    end
  end
end
