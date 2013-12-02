require 'spec_helper'

describe Event do
  it 'does not save without an event type' do
    e = Event.new
    e.save.should be_false
  end

  it 'stores date' do
    e = Event.new
    e.event_type = 'foo'
    e.save!
    e.date.should == Date.today
  end
end
