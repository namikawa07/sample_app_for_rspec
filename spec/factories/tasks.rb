FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "RSpec Test_#{n}"}
    status {1}
    association :user
  end
end
