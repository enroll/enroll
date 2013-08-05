require 'spec_helper'

describe User do
  let(:user) { build(:user) }

  it { should have_many(:reservations) }
  it { should have_many(:courses_as_student) }
  it { should have_many(:courses_as_instructor) }

  it { should validate_presence_of(:email) }

  describe 'courses' do
    before(:each) do
      user.save
      @instructor_course = create(:course, instructor: user)
      @student_course = create(:course)
      create(:reservation, student: user, course: @student_course)
    end

    it 'includes courses the user is taking as a student' do
      user.courses.should include(@student_course)
    end

    it 'includes courses that the user is teaching' do
      user.courses.should include(@instructor_course)
    end
  end

  describe 'display_title' do
    it 'is the same as the user email' do
      user.display_title.should == user.email
    end
  end

end
