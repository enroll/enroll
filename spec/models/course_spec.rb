require 'spec_helper'

describe Course do
  let(:course) { build(:course) }

  it "has a name" do
    course.name = "Cow Tipping 101"
    course.name.must_equal "Cow Tipping 101"
  end
end
