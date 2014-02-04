require "spec_helper"

describe Dashboard::CoursesController do
  let(:user) { create(:user) }
  before { sign_in(user) }

  describe "#new" do
    render_views
    
    it "returns ok" do
      get :new, step: 'details'
      response.should be_ok
    end
  end

  describe "#update" do
    let(:course) { create(:course, instructor: user, price_per_seat_in_cents: 2000) }

    it "saves the price" do
      course.published?.should be_false
      course.price_per_seat_in_cents.should == 2000

      put :update, id: course.id, step: 'pricing', course: {price_per_seat_in_dollars: 5}
      response.should redirect_to edit_dashboard_course_path(course, :step => 'page')
      course.reload.price_per_seat_in_cents.should == 500
    end
  end

  describe "#publish" do
    let(:user) { create(:user) }
    let(:course) { create(:course, instructor: user) }

    it "publishes the course" do
      course.should_not be_published
      get :publish, id: course.id
      course.reload.should be_published
    end

    it "does not publish if date is in the past" do
      course.starts_at = Date.yesterday
      course.ends_at = Date.yesterday
      course.save!

      course.should_not be_published
      get :publish, id: course.id
      course.reload.should_not be_published
    end


  end
end