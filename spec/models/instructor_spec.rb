require 'spec_helper'

describe Instructor do
  let(:instructor) { build(:instructor) }

  it { should have_many(:courses) }

  it { should validate_presence_of(:email) }

  context "#current_course" do
    it "returns nil if the instructor has no courses" do
      instructor.current_course.should be_nil
    end

    context "with future courses" do
      let!(:later_course) { create(:course, course_starts_at: Date.today + 20, instructor: instructor) }
      let!(:next_course) { create(:course, course_starts_at: Date.today + 10, instructor: instructor) }

      it "returns the next upcoming course" do
        instructor.current_course.should == next_course
      end
    end

    context "with only past courses" do
      let!(:long_ago_course) { create(:course, course_starts_at: Date.yesterday - 20, instructor: instructor) }
      let!(:recent_past_course) { create(:course, course_starts_at: Date.yesterday, instructor: instructor) }

      it "returns the most recent past course" do
        instructor.current_course.should == recent_past_course
      end
    end

    context "with courses with no dates" do
      let!(:course) { create(:course, instructor: instructor) }

      it "returns any course" do
        instructor.current_course.should == course
      end
    end
  end
end
