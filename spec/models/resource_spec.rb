require 'spec_helper'

describe Resource do
  it { should validate_presence_of(:course_id) }
  it { should validate_presence_of(:name) }

  it "checks type of resource" do
    resource = Resource.new(resource_type: 'file')
    resource.should be_file

    resource = Resource.new(resource_type: 'link')
    resource.should be_link
  end
end
