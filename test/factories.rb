FactoryGirl.define do
  factory :workshop do
    name "Space Monkeys Learn Java"
  end

  factory :reservation do
    workshop
  end
end
