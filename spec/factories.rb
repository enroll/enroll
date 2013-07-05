FactoryGirl.define do
  factory :course do
    name "Space Monkeys Learn Java"
    location
  end

  factory :reservation do
    course
  end

  factory :location do
    name "The Corner Pub"
  end
end
