FactoryBot.define do
  sequence :body do |n|
    "MyText#{n}"
  end

  factory :answer do
    body
    question
    association :author, factory: :user

    trait :invalid do
      body { nil }
      question
    end
  end

end
