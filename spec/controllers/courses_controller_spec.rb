require 'spec_helper'

describe CoursesController do
  let(:course) { build(:course) }
  let(:course_attributes) { attributes_for(:course) }

  context "GET show" do
    before { course.save }

    it "renders the show page" do
      get :show, :id => course.to_param
      must_render_template :show
    end
  end
end
