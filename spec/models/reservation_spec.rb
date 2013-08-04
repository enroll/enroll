require 'spec_helper'

describe Reservation do
  let(:instructor)  { build(:instructor) }
  let(:course)      { build(:course, instructor: instructor) }
  let(:student)     { build(:student) }
  let(:reservation) { build(:reservation, student: student, course: course) }

  it { should belong_to(:course) }
  it { should belong_to(:student) }

  it { should validate_presence_of(:course) }
  it { should validate_presence_of(:student) }

  context "#instructor" do
    it "should be the instructor of the course" do
      reservation.instructor.should == instructor
    end
  end
end
