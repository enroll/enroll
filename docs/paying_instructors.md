# Paying Instructors

A payout needs to be initiated with Stripe from our enroll account to the Instructor's bank account.

For now, we'll initiate each transfer manually via the console since it involves moneys, and potentially large amounts of it.

## Initiate a payout via the console

Find the course that needs to be paid out.

```ruby
course = Course.find(some_id)
=> #<Course>
course.title # check the title of the course
=> "Ruby on Rails for Beginners"
course.pay_instructor!
=> true
```

Now I'd go check out the [Strie interface](https://manage.stripe.com) to make sure  there's a transfer there. 

The transfer should be completed in the next 1-2 business days.

---











```ruby
course.revenue # total amount the course made
=> 250000
course.reservations.count # number of tickets sold
=> 25
course.price_per_seat_in_cents # cost of each ticket
=> 10000
course.credit_card_fees # total credit card fees
=> 8000
course.gross_profit # total amount that enroll made
=> 7750
course.instructor_payout # total amount to pay to the instructor
=> 234950
```

You might want to check the computer's math. It's a lot of money.

```ruby
course.revenue == course.instructor_payout + course.gross_profit + course.credit_card_fees
=> true
```

Now I'd go check out the [Stripe interface](https://manage.stripe.com) to make sure there are the correct number of transactions for the number of tickets sold. Also, make sure that the money for the instructor payout is all there.

Ok. If you think you're ready to initiate the payout, go ahead.

```ruby
payout = Payout.create({
  amount_in_cents: course.price_per_seat_in_cents, 
  description: course.name, 
  stripe_recipient_id: course.instructor.stripe_recipient_id
})
=> #<Payout id: 1, stripe_transfer_id: nil, stripe_recipient_id: "rp_2rAHV7u3t4lL4i", status: "pending", description: "Test-Driven Development for Rails", amount_in_cents: 85000>
payout.request
=> true
payout.status
=> "requested"
```

