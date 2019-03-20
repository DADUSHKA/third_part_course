FactoryBot.define do
  sequence :body do |n|
    "MyText#{n}"
  end

  factory :answer do
    body
    question

    trait :invalid do
      body { nil }
      question
    end
  end

end
