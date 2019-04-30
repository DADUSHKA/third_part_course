FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "MyComment#{n}" }

    user

    trait :invalid do
      body { nil }
    end
  end
end
