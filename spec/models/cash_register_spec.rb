require 'spec_helper'

describe CashRegister do
  let(:course) { build(:course) }

  describe "#revenue" do
    context "paid course" do
      before do
        10.times { create(:reservation, course: course) }
      end

      it "returns total value of course tickets sold with a different amount" do
        course.price_per_seat_in_cents = 5000 # $50
        course.save
      	CashRegister.revenue(course).should == 50000
	  end

      it "returns total value of course tickets sold ignoring fees" do
        course.price_per_seat_in_cents = 10000 # $100
        course.save
        CashRegister.revenue(course).should == 100000 # $1,000
      end
    end

    context "free course" do
      before do
        course.price_per_seat_in_cents = 0
        course.save
        10.times { create(:reservation, course: course) }
      end

      it "returns zero for free courses" do
        CashRegister.revenue(course).should == 0
      end

      it "returns zero even if price per seat is not set" do
      	course.price_per_seat_in_cents = nil
        CashRegister.revenue(course).should == 0
      end
    end
  end

  describe "#credit_card_fees" do
    context "paid course" do
      before do
        course.price_per_seat_in_cents = 10000 # $100
        course.save
        10.times { create(:reservation, course: course) }
      end

      it "returns credit card fees" do
        # Course revenue: $1,000
        # CC percentage fees: $1,000 x 2.9% = $29
        # CC transaction fees: 10 tix x $0.30 = $3
        CashRegister.credit_card_fees(course).should == 3200 # $32
      end
    end

    context "free course" do
      before do
        course.price_per_seat_in_cents = 0
        course.save
        10.times { create(:reservation, course: course) }
      end

      it "returns zero for free courses" do
        CashRegister.credit_card_fees(course).should == 0
      end
    end
  end

  describe "#gross_profit" do
    context "paid course" do
      before do
        course.price_per_seat_in_cents = 10000 # $100
        course.save
        10.times { create(:reservation, course: course) }
      end

      it "returns enroll's cut of the revenue (gross profit)" do
        # Course revenue: $1,000
        # Enroll service fees: $1,000 x 3.1% = $31
        CashRegister.gross_profit(course).should == 3100 # $31
      end
    end

    context "free course" do
      before do
        course.price_per_seat_in_cents = 0
        course.save
        10.times { create(:reservation, course: course) }
      end

      it "returns zero for free courses" do
        CashRegister.gross_profit(course).should == 0
      end
    end
  end

  describe "#instructor_payout_amount" do
    context "paid course" do
      before do
        course.price_per_seat_in_cents = 10000 # $100
        course.save
        10.times { create(:reservation, course: course) }
      end

      it "returns the instructor's cut of the course" do
        # Course revenue: $1,000
        # Enroll service fees: $1,000 x 3.1% = $31
        # CC percentage fees: $1,000 x 2.9% = $29
        # CC transaction fees: 10 tix x $0.30 = $3
        # Instructor payout: $1,000 - $31 - $29 - $3 = $937
        CashRegister.instructor_payout_amount(course).should == 93700 # $937
      end
    end

    context "free course" do
      before do
        course.price_per_seat_in_cents = 0
        course.save
        10.times { create(:reservation, course: course) }
      end

      it "returns zero for free courses" do
        CashRegister.instructor_payout_amount(course).should == 0
      end
    end
  end
end