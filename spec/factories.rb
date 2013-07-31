FactoryGirl.define do
  factory :course do
    name                 { "Space Monkeys Learn Java" }
    tagline              { "You'll be peeling XML bananas in no time." }
    starts_at            { 2.weeks.from_now }
    ends_at              { 2.weeks.from_now + 4.hours }
    description          { "Learn NetBeans, Eclipse, and Static Typing" }
    instructor_biography { "Professor Ben Ann Ugh has been teaching for 40 years." }
    min_seats            { 10 }
    max_seats            { 25 }
    price_per_seat       { 149.99 }

    # associations
    location
    instructor factory: :user
  end

  factory :reservation do
    course
    user
  end

  factory :location do
    name "The Corner Pub"
  end

  factory :user do
    sequence(:email) {|n| "user#{n}@example.com" }
    password "password"
  end
end
