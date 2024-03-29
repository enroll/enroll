FactoryGirl.define do
  factory :course do
    name                             { "Space Monkeys Learn Java" }
    tagline                          { "You'll be peeling XML bananas in no time." }
    starts_at                        { 2.weeks.from_now }
    ends_at                          { 2.weeks.from_now + 4.hours }
    campaign_ends_at                 { 1.week.from_now }
    campaign_failed_at               { nil }
    campaign_ending_soon_reminded_at { nil }
    description                      { "Learn NetBeans, Eclipse, and Static Typing" }
    instructor_biography             { "Professor Ben Ann Ugh has been teaching for 40 years." }
    min_seats                        { 10 }
    max_seats                        { 25 }
    price_per_seat_in_cents          { 14999 }
    url                              { "space-monkeys-learn-java" }

    # associations
    location
    instructor factory: :instructor
  end

  factory :cover_image do
    course
    image File.open(Rails.root.join('spec', 'fixtures', 'unicorn.jpg'))
  end

  factory :reservation do
    course
    student
  end

  factory :schedule, class: CourseSchedule do
    course
    date Date.today
  end

  factory :location do
    name "The Corner Pub"
  end

  factory :resource do
    name "MyString"
    description "MyString"
    s3_url "MyString"
    transloadit_assembly_id "MyString"
  end

  factory :event do
  end
  
  factory :payout do
    amount_in_cents 15000 # $150 USD
    description 'How to raise seed funding'
    stripe_recipient_id 12345

    factory :payout_requested do
      status "requested"
    end

    factory :payout_completed do
      status "paid"
    end
  end

  factory :user do
    sequence(:email) {|n| "user#{n}@example.com" }
    password "password"

    factory :student do
      sequence(:email) {|n| "student#{n}@example.com" }
    end

    factory :instructor do
      sequence(:email) {|n| "instructor#{n}@example.com" }
    end
  end
end
