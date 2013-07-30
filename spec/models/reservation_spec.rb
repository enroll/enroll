require 'spec_helper'

describe Reservation do
  let(:reservation) { build(:reservation) }

  it { should belong_to(:course) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:course) }
  # it { should validate_presence_of(:user) }
end
