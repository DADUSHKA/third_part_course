FactoryBot.define do
  factory :link do
    name { 'My Link' }
    url { 'https://github.com' }
    association :linkable
  end
end
