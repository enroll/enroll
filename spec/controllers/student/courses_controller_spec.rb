require "spec_helper"

describe Student::CoursesController do
  let(:student) { create(:student) }
  let(:course) { create(:course) }

  before(:each) do
    sign_in(student)
    reservation = create(:reservation, student: student, course: course)
    CourseSchedule.create!({
      course_id: course.id,
      date: Date.new(2014, 4, 7),
      starts_at: "9:00am",
      ends_at: "5:30pm"
    })
  end

  describe "#index" do
    it "finds student's course" do
      get :show, id: course.id
      response.should_not redirect_to(root_path)
      response.should be_ok
      assigns(:course).should == course
    end

    it "redirects to home if student doesn't own the course" do
      get :show, id: create(:course).id
      response.should redirect_to(root_path)
    end
  end

  describe "#calendar" do
    it "generates ical file" do
      get :calendar, id: course.id, format: 'ics'

      response.body.tap { |r|
        r.should include("DTSTART:20140407T090000")
        r.should include("DTEND:20140407T173000")
      }
    end
  end
end