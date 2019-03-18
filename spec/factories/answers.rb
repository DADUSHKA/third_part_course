FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question
    association :author, factory: :user

    trait :invalid do
      body { nil }
      question
    end
  end

end
