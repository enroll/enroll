FactoryGirl.define do
  factory :course do
    name "Space Monkeys Learn Java"
    location
  end

  factory :location do
    name "The Corner Pub"
  end

  factory :payout do
    amount_in_cents 15000 # $150 USD
    description 'Course: How to raise seed funding'
    stripe_recipient_id 12345

    factory :payout_requested do
      status "requested"
    end

    factory :payout_completed do
      status "paid"
    end
  end

  factory :reservation do
    course
  end
end
