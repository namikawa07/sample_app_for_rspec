FactoryBot.define do
  factory :user, aliases: [:owner] do
    sequence(:email) { |n| "tester_#{n}@example.com"}
    password { 'Rspec-tester-password' }
    password_confirmation { "Rspec-tester-password" }
  end
end
