FactoryBot.define do
  factory :vote do
    choice { 1 }
    user
    association :voteable, factory: :answer
  end
end
