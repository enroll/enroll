require 'spec_helper'

describe User do
  let(:user) { build(:user) }

  it { should have_many(:courses) }

  it { should validate_presence_of(:email) }

  context "#current_course" do
    it "returns nil if the user has no courses" do
      user.current_course.should be_nil
    end

    context "with future courses" do
      let!(:later_course) { create(:course, course_starts_at: Date.today + 20, instructor: user) }
      let!(:next_course) { create(:course, course_starts_at: Date.today + 10, instructor: user) }

      it "returns the next upcoming course" do
        user.current_course.should == next_course
      end
    end

    context "with only past courses" do
      let!(:long_ago_course) { create(:course, course_starts_at: Date.yesterday - 20, instructor: user) }
      let!(:recent_past_course) { create(:course, course_starts_at: Date.yesterday, instructor: user) }

      it "returns the most recent past course" do
        user.current_course.should == recent_past_course
      end
    end

    context "with courses with no dates" do
      let!(:course) { create(:course, instructor: user) }

      it "returns any course" do
        user.current_course.should == course
      end
    end
  end
end
