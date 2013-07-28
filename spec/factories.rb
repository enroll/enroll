FactoryGirl.define do
  factory :course do
    name                 { "Space Monkeys Learn Java" }
    tagline              { "You'll be peeling XML bananas in no time." }
    course_starts_at     { 2.weeks.from_now }
    course_ends_at       { 2.weeks.from_now + 4.hours }
    description          { "Learn NetBeans, Eclipse, and Static Typing" }
    instructor_biography { "Professor Ben Ann Ugh has been teaching for 40 years." }
    min_seats            { 10 }
    max_seats            { 25 }
    price_per_seat       { 14999 } # $149.99

    # associations
    location
    instructor factory: :user
  end

  factory :reservation do
    course
  end

  factory :location do
    name "The Corner Pub"
  end

  factory :user do
    sequence(:email) {|n| "user#{n}@example.com" }
    password "password"
  end
end
