require 'test_helper'

describe Workshop do
  let(:workshop) { build(:workshop) }

  it "has a name" do
    workshop.name = "Cow Tipping 101"
    workshop.name.must_equal "Cow Tipping 101"
  end
end
