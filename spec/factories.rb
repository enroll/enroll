FactoryGirl.define do
  factory :course do
    name "Space Monkeys Learn Java"
  end

  factory :reservation do
    course
  end
end
