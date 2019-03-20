FactoryBot.define do
  sequence :titles do |n|
    "MyString#{n}"
  end

  factory :question_s, parent: :question do
    title { generate(:titles) }
    body { "MyText" }
  end

  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end
