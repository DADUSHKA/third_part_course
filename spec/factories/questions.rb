FactoryBot.define do
  sequence :titles do |n|
    "MyString#{n}"
  end

  factory :question_s, parent: :question do
    title { generate(:titles) }
    body { 'MyText' }
    association :author, factory: :user
  end

  factory :question do
    title { 'MyString' }
    body { 'MyText' }
    association :author, factory: :user

    trait :with_file do
      files { FilesTestHelper.pdf }
    end

    trait :invalid do
      title { nil }
    end
  end
end
