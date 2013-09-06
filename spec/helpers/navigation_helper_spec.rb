require 'spec_helper'

class NavigationTest
  include NavigationHelper

  attr_accessor :user, :course, :controller_name, :flash

  def initialize(options={})
    options.each { |k,v| instance_variable_set("@#{k}", v) }
  end
end

describe NavigationHelper do
  let(:user) { build(:user) }
  let(:course) { build(:course) }

  before(:each) do
    @nav = NavigationTest.new(user: user, course: course)
  end

  describe 'nav_signupbox_class' do
    it 'returns nil if there are no errors' do
      @nav.nav_signupbox_class.should be_nil
    end

    it 'returns nil if user and course are not set' do
      @nav.course = nil
      @nav.user = nil
      @nav.nav_signupbox_class.should be_nil
    end

    it 'returns "in" if there are @user errors' do
      @nav.user.stubs(:errors).returns({ name: 'is invalid' })
      @nav.nav_signupbox_class.should == 'in'
    end

    it 'returns "in" if there are @course errors' do
      @nav.course.stubs(:errors).returns({ name: 'is invalid' })
      @nav.nav_signupbox_class.should == 'in'
    end

    it 'returns nil regardless of errors if we are creating a reservation' do
      @nav.user.stubs(:errors).returns({ name: 'is invalid' })
      @nav.stubs(:controller_name).returns('reservations')
      @nav.nav_signupbox_class.should be_nil
    end
  end

  describe 'nav_loginbox_class' do
    it 'returns nil if no flash alert is set' do
      @nav.flash = OpenStruct.new({ success: 'hurray' })
      @nav.nav_loginbox_class.should be_nil
    end

    it 'returns "in" if a flash alert is present' do
      @nav.flash = OpenStruct.new({ alert: 'ohno' })
      @nav.nav_loginbox_class.should == 'in'
    end
  end

  describe 'course_short_url' do
    it 'returns the course url properly constructed' do
      course = build(:course, url: 'my-fresh-course')
      course_short_url(course).should == '/go/my-fresh-course'
    end
  end
end
