require 'spec_helper'

describe Resource do
  it { should validate_presence_of(:course_id) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:s3_url) }
end
