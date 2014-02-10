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
        post :create, course_id: course.id, 
                      resource: {name: 'foo', description: 'bar'}, 
                      transloadit: transloadit_params
      }.to change{Resource.count}.by(1)

      Resource.last.tap { |r|
        r.name.should == 'foo'
        r.description.should == 'bar'
      }
    end

    it "on success from transloadit, saves the s3_url and assembly_id" do
      post :create, course_id: course.id, 
                    resource: {name: 'foo', description: 'bar'}, 
                    transloadit: transloadit_params

      resource = Resource.last
      resource.s3_url.should == "some-url"
      resource.transloadit_assembly_id.should == "some-id"
      response.should redirect_to(dashboard_course_resources_path(course))
    end

    it "on upload failure renders new" do
      post :create, course_id: course.id,
                    resource: {name: 'foo', description: 'bar'}, 
                    transloadit: transloadit_failing_params

      response.should be_ok
      response.should render_template('new')
    end

    it "renders new if response from translaodit is empty" do
      post :create, course_id: course.id,
                    resource: {name: 'foo', description: 'bar'},
                    transloadit: transloadit_empty_params
      response.should be_ok
      response.should render_template('new')
    end
  end

  describe "#destroy" do
    it "deletes resource" do
      resource # create resource
      expect {
        delete :destroy, course_id: course.id, id: resource.id
      }.to change{Resource.count}.by(-1)
    end
  end

  def transloadit_params
    {
      ok: "ASSEMBLY_COMPLETED", 
      assembly_id: "some-id",
      results: {
        ":original" => [{
          url: "some-url"
        }]
      }
    }.to_json
  end

  def transloadit_empty_params
    {
      ok: 'ASSEMBLY_COMPLETED',
      assembly_id: 'some-id',
      results: {}
    }.to_json
  end

  def transloadit_failing_params
    {error: "INVALID_FILE_META_DATA"}.to_json
  end
end