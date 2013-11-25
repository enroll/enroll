class CashRegister

	def self.revenue(course)
		return 0 if course.free?
		course.price_per_seat_in_cents * course.reservations.count
	end

  # Stripe takes a 2.9% cut of every ticket sold and 30 cents per ticket
  STRIPE_CREDIT_CARD_PERCENTAGE = 0.029             #  2.9%
  STRIPE_CREDIT_CARD_TRANSACTION_FEE_IN_CENTS = 30  # $0.30

	def self.credit_card_fees(course)
		return 0 if course.free?
		(revenue(course) * STRIPE_CREDIT_CARD_PERCENTAGE) + (course.reservations.count * STRIPE_CREDIT_CARD_TRANSACTION_FEE_IN_CENTS)
	end

  # Enroll takes a 3.1% cut of every ticket sold
  ENROLL_SERVICE_FEE_PERCENTAGE = 0.031  # 3.1%

	def self.gross_profit(course) 
		return 0 if course.free?
		revenue(course) * ENROLL_SERVICE_FEE_PERCENTAGE
	end

	def self.instructor_payout_amount(course)
		revenue(course) - gross_profit(course) - credit_card_fees(course)
	end
end