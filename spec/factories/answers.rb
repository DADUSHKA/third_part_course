FactoryBot.define do
  sequence :body do |n|
    "MyTextAnswer#{n}"
  end

  factory :best_answer, class: Answer do
    body
    best { true }
    question
    association :author, factory: :user
  end

  factory :answer do
    body
    best { false }
    question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
