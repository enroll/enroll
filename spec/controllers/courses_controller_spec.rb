require 'spec_helper'

describe CoursesController do
  let(:course) { build(:course) }
  let(:course_attributes) { attributes_for(:course).merge({ location_attributes: attributes_for(:location)}) }
  let(:saved_course) { create(:course, instructor: user, name: 'foo') }
  let(:user) { create(:user) }

  context "GET show" do
    render_views
    
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

    it "creates an event about page being visited" do
      get :show, url: course.url
      Event.last.tap { |e|
        e.event_type.should == Event::PAGE_VISITED
        e.course.should == course
      }
    end

    it "works ok with description being nil" do
      course.description = nil
      course.save!
      get :show, url: course.url
      response.should be_success
    end
  end

  context "GET index" do
    before { course.save }

    it "renders the index" do
      sign_in(user)
      get :index
      response.should be_success
      response.should render_template :index
    end

    it "includes some courses" do
      sign_in(user)
      get :index
      assigns[:courses_teaching].should_not be_nil
      assigns[:courses_studying].should_not be_nil
    end
  end

  context "POST create" do
    context "when not logged in" do
      it "redirects to login" do
        post :create, course: course_attributes
        response.should be_redirect
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  context "creating courses through multi-step form" do
    before { sign_in(user) }

    context "visiting new course page" do
      it "redirects to the first step" do
        get :new
        response.should redirect_to new_course_step_path(:step => 'details')
      end
    end

    context "unexisting step" do
      it "redirects to the first step" do
        get :new, :step => 'blah'
        response.should redirect_to new_course_step_path(:step => 'details')

        get :edit, id: saved_course.to_param, step: 'blah'
        response.should redirect_to edit_course_step_path(:step => 'details')
      end
    end

    context "step: details" do
      let(:details_attributes) { {name: 'foo', tagline: 'bar'} }

      it "renders the form" do
        get :new, :step => 'details'
        response.should be_success
      end

      it "creates new course" do
        expect {
          post :create, step: 'details', course: details_attributes
        }.to change(Course, :count)
        Course.last.name.should == 'foo'
      end

      it "sets the instructor" do
        post :create, step: 'details', course: details_attributes
        Course.last.instructor.should == user
      end

      it "redirects to the next step" do
        post :create, step: 'details', course: details_attributes
        response.should redirect_to edit_course_step_path(Course.last.id, 'dates_location')
      end

      context "invalid data" do
        it "renders the form" do
          post :create, step: 'details', course: {junk: 1}
          response.should render_template :new
        end
      end
    end

    context "step: dates and location" do
      it "renders the form" do
        get :edit, id: saved_course.to_param, step: 'dates_location'
        response.should render_template :edit
      end

      it "redirects to pricing step" do
        put :update, id: saved_course.to_param, step: 'dates_location', course: {location_attributes: {name: 'library'}}
        response.should redirect_to edit_course_step_path(saved_course.to_param, 'pricing')
      end
    end

    context "step: pricing" do
      it "redirects to the page step" do
        put :update, id: saved_course.to_param, step: 'pricing', course: {price_per_seat_in_cents: 1000}
        response.should redirect_to edit_course_step_path(saved_course.to_param, 'page')
      end
    end

    context "last step (landing page)" do
      it "redirects to the course page" do
        put :update, id: saved_course.to_param, step: 'page', course: {description: '# foo'}
        response.should redirect_to course_path(saved_course.to_param)
      end

      it "creates an event about course creation" do
        expect {
          put :update, id: saved_course.to_param, step: 'page', course: {description: '# foo'}
        }.to change { Event.count }.by(1)
        Event.last.tap { |e|
          e.event_type.should == 'course_created'
          e.course.should == saved_course
        }
      end
    end

  end

  context "PUT update" do
    before { sign_in(user) }

    context "draft mode" do
      before {
        saved_course.price_per_seat_in_cents = 200
        saved_course.min_seats = 10
        saved_course.starts_at = Date.today
        saved_course.ends_at = Date.today
        saved_course.url = "foo"
        saved_course.save!
        saved_course.publish!
      }

      it "does not allow changing price" do
        put :update, id: saved_course.to_param, step: 'pricing', course: {price_per_seat_in_dollars: 5}
        saved_course.reload.price_per_seat_in_cents.should == 200
      end

      it "does not allow changing min seats" do
        put :update, id: saved_course.to_param, step: 'pricing', course: {min_seats: 5}
        saved_course.reload.min_seats.should == 10
      end

      it "does not allow changing dates" do
        put :update, id: saved_course.to_param, step: 'dates_location', course: {starts_at: '2014-01-01', ends_at: '2014-01-01'}
        saved_course.reload
        saved_course.starts_at.should == Date.today
        saved_course.ends_at.should == Date.today
      end

      it "does not allow changing url" do
        put :update, id: saved_course.to_param, step: 'details', course: {url: 'bazinga'}
        saved_course.reload.url.should == 'foo'
      end
    end 
  end

  context "GET edit" do
    before { course.save }

    context "when logged in but not course owner" do
      it "redirects to the root page" do
        sign_in(user)
        get :edit, id: course.to_param
        response.should be_redirect
        response.should redirect_to(root_path)
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        get :edit, id: course.to_param
        response.should be_redirect
        response.should redirect_to(new_user_session_path)
      end
    end
  end
end
