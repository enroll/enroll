FactoryGirl.define do
  factory :course do
    name                    { "Space Monkeys Learn Java" }
    tagline                 { "You'll be peeling XML bananas in no time." }
    starts_at               { 2.weeks.from_now }
    ends_at                 { 2.weeks.from_now + 4.hours }
    campaign_ends_at        { 1.week.from_now }
    description             { "Learn NetBeans, Eclipse, and Static Typing" }
    instructor_biography    { "Professor Ben Ann Ugh has been teaching for 40 years." }
    min_seats               { 10 }
    max_seats               { 25 }
    price_per_seat_in_cents { 14999 }

    # associations
    location
    instructor factory: :instructor
  end

  factory :reservation do
    course
    student
  end

  factory :location do
    name "The Corner Pub"
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
