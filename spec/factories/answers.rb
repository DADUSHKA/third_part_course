FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question

    trait :invalid do
      body { nil }
      question
    end
  end

end
