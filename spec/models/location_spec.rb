require 'spec_helper'

describe Location do
  let(:location) { build(:location) }

  it { should have_many(:courses) }

  # it { should validate_presence_of(:name) }

  describe "zip_and_state" do
    it "returns the correct value based on values present" do
      location.state = ""
      location.zip = ""
      location.zip_and_state.should == ""

      location.state = "California"
      location.zip = "94107"
      location.zip_and_state.should == "California 94107"

      location.state = "California"
      location.zip = nil
      location.zip_and_state.should == "California"
    end
  end

  describe "city_and_state" do
    it "returns the correct value based on values present" do
      location.state = ""
      location.city = "Boston"
      location.city_and_state.should == "Boston"

      location.state = "MA"
      location.city = nil
      location.city_and_state.should == "MA"

      location.state = "MA"
      location.city = "Boston"
      location.city_and_state.should == "Boston, MA"
    end
  end
end
