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
end
