FactoryBot.define do
  sequence :body do |n|
    "MyTextAnswer#{n}"
  end

  factory :answer do
    body
    question
    association :author, factory: :user

    trait :with_file do
      files { FilesTestHelper.pdf }
    end

    trait :invalid do
      body { nil }
    end
  end
end
