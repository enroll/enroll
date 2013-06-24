require 'spec_helper'

describe Reservation do
  let(:course) { build(:course) }
  let(:reservation) { build(:reservation) }

  it "belongs to a course" do
    reservation.course = course
    reservation.course.must_equal course
  end

  it "requires a course" do
    reservation.course = nil
    reservation.valid?
    reservation.errors[:course].must_include "can't be blank"
  end
end
