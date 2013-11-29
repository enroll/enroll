require 'spec_helper'

describe Event do
  it 'does not save without an event type' do
    e = Event.new
    e.save.should be_false
  end
end
