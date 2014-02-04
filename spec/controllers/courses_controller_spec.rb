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
end
