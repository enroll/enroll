require 'spec_helper'

describe CoursesController do
  let(:course) { build(:course) }
  let(:course_attributes) { attributes_for(:course).merge({ location_attributes: attributes_for(:location)}) }
  let(:user) { create(:user) }

  context "GET show" do
    before { course.save }

    it "renders the show page" do
      get :show, id: course.to_param
      assigns[:course].should == course
      response.should be_success
      response.should render_template :show
    end

    it "renders the landing page via landing page url" do
      get :show, url: course.url
      assigns[:course].should == course
      response.should be_success
      response.should render_template :show
    end
  end

  context "GET index" do
    before { course.save }

    it "renders the index" do
      get :index
      response.should be_success
      response.should render_template :index
    end

    it "includes some courses" do
      get :index
      assigns[:courses].should_not be_nil
    end
  end

  context "POST create" do
    context "when logged in" do
      before { sign_in(user) }

      it "creates a course" do
        expect {
          post :create, course: course_attributes
        }.to change(Course, :count)
      end

      it "redirects to the reservation" do
        post :create, course: course_attributes
        response.should be_redirect
        response.should redirect_to(course_path(assigns[:course]))
      end

      it "sets the success flash" do
        post :create, course: course_attributes
        flash[:success].should_not be_nil
      end

      it "sets the instructor" do
        post :create, course: course_attributes
        user.courses.count.should == 1
      end

      context "when submitting invalid data" do
        before { Course.any_instance.stubs(:save).returns(false) }

        it "renders the new page" do
          post :create, course: { junk: '1' }
          response.should render_template :new
        end

        it "sets the error flash" do
          post :create, course: { junk: '1' }
          flash[:error].should_not be_nil
        end
      end
    end

    context "when not logged in" do
      it "redirects to root" do
        post :create, course: course_attributes
        response.should be_redirect
        response.should redirect_to(root_path)
      end
    end
  end

  context "GET edit" do
    before { course.save }

    context "when logged in and course owner" do
      it "renders the edit page" do
        course.instructor = user
        course.save
        sign_in(user)
        get :edit, id: course.to_param
        response.should be_success
        response.should render_template :edit
      end
    end

    context "when logged in but not course owner" do
      it "redirects to the root page" do
        sign_in(user)
        get :edit, id: course.to_param
        response.should be_redirect
        response.should redirect_to(root_path)
      end
    end

    context "when not logged in" do
      it "redirects to the root page" do
        get :edit, id: course.to_param
        response.should be_redirect
        response.should redirect_to(root_path)
      end
    end
  end

  context "PUT update" do
    before do
      course.instructor = user
      course.save

      sign_in(user)
    end

    it "updates the course" do
      put :update, id: course.to_param, course: { name: 'Linux Administration 101' }
      course.reload.name.should == 'Linux Administration 101'
    end

    it "redirects to the edit course page" do
      put :update, id: course.to_param, course: { name: 'Linux Administration 101' }
      response.should redirect_to edit_course_path(course)
    end

    it "sets the success flash" do
      put :update, id: course.to_param, course: { name: 'Linux Administration 101' }
      flash[:success].should_not be_nil
    end

    context "when submitting invalid data" do
      before { Course.any_instance.stubs(:update_attributes).returns(false) }

      it "renders the edit page" do
        put :update, id: course.to_param, course: { junk: '1' }
        response.should render_template :edit
      end

      it "sets the error flash" do
        put :update, id: course.to_param, course: { junk: '1' }
        flash[:error].should_not be_nil
      end
    end
  end
end
