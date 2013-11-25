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
