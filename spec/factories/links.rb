FactoryBot.define do
  factory :link do
    name { 'My Link' }
    url { 'https://github.com' }
    association :linkable, factory: :question
  end

  factory :link_answer do
    name { 'My Link' }
    url { 'https://github.com' }
    association :linkable, factory: :answer
  end
end
