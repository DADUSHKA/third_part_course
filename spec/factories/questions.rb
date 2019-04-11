FactoryBot.define do
  sequence :titles do |n|
    "MyString#{n}"
  end

  factory :question_s, parent: :question do
    title { generate(:titles) }
    body { 'MyText' }
    association :author, factory: :user

    # trait :with_avatar do
    #   after :create do |question_s|
    #     file_path = Rails.root.join('spec', 'support', 'assets', 'test.pdf')
    #     file = fixture_file_upload(file_path, 'application/pdf')
    #     question_s.avatar.attach(file)
    #   end
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
