require 'spec_helper'

describe Location do
  let(:location) { build(:location) }

  it { should have_many(:courses) }

  it { should validate_presence_of(:name) }
end
