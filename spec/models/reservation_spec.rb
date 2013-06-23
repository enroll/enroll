require 'spec_helper'

describe Reservation do
  let(:course) { build(:course) }

  it "belongs to a workshop" do
    reservation = Reservation.new(:course => course)
    reservation.course.must_equal course
  end
end
