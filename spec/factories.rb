FactoryGirl.define do
  factory :course do
    name "Space Monkeys Learn Java"
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
