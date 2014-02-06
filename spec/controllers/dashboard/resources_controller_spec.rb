require "spec_helper"

describe Dashboard::ResourcesController do
  let(:user) { create(:user) }
  let(:course) { create(:course, instructor: user) }
  let(:resource) { create(:resource, course: course) }

  before { sign_in(user) }

  describe "#index" do
    it "lists resources for a course" do
      resource
      get :index, course_id: course.id
      assigns(:resources).should_not be_nil
      assigns(:resources).count.should == 1
      assigns(:resources).first.should == resource
    end
  end

  describe "#create" do
    it "creates the resource" do
      expect {
        post :create, course_id: course.id, resource: {name: 'foo', description: 'bar', s3_url: '123'}
      }.to change{Resource.count}.by(1)
      Resource.last.tap { |r|
        r.name.should == 'foo'
        r.description.should == 'bar'
        r.s3_url.should == '123'
      }
    end
  end
end