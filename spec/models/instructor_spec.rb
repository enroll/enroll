require 'spec_helper'

describe Instructor do
  let(:instructor) { build(:instructor) }

  it { should have_many(:courses) }

  it { should validate_presence_of(:email) }

end
