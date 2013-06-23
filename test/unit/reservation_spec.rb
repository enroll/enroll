require 'test_helper'

describe Reservation do
  let(:workshop) { build(:workshop) }

  it "belongs to a workshop" do
    reservation = Reservation.new(:workshop => workshop)
    reservation.workshop.must_equal workshop
  end
end
