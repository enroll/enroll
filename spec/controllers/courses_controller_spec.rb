require 'spec_helper'

describe CoursesController do
  let(:course) { build(:course) }
  let(:course_attributes) { attributes_for(:course) }

  context "GET new" do
    it "renders the new page" do
      get :new
      must_respond_with :success
      must_render_template :new
    end

    it "initializes a new course" do
      get :new
      assigns[:course].wont_be_nil
    end
  end

  context "GET show" do
    before { course.save }

    it "renders the show page" do
      get :show, :id => course.to_param
      must_render_template :show
    end
  end

  context "GET index" do
    before { course.save }

    it "renders the index" do
      get :index
      must_respond_with :success
      must_render_template :index
    end

    it "includes some courses" do
      get :index
      assigns[:courses].wont_be_nil
    end
  end

  context "POST create" do
    it "creates a course" do
      assert_difference "Course.count" do
        post :create, course: course_attributes
      end
    end

    it "redirects to the reservation" do
      post :create, course: course_attributes
      must_redirect_to course_path(assigns[:course])
    end

    it "sets the success flash" do
      post :create, course: course_attributes
      flash[:success].wont_be_nil
    end

    context "when submitting invalid data" do
      before { Course.any_instance.stubs(:save).returns(false) }

      it "renders the new page" do
        post :create, course: { junk: '1' }
        must_render_template :new
      end

      it "sets the error flash" do
        post :create, course: { junk: '1' }
        flash[:error].wont_be_nil
      end
    end
  end
end
