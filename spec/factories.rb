FactoryGirl.define do
  factory :course do
    name "Space Monkeys Learn Java"
    location
    instructor
  end

  factory :reservation do
    course
  end

  factory :location do
    name "The Corner Pub"
  end

  factory :instructor do
    sequence(:email) {|n| "instructor#{n}@example.com" }
    password "password"
  end
end
