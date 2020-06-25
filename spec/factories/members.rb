FactoryBot.define do
  factory :member do
    article { nil }
    user { nil }
    role { "MyString" }
    active { false }
  end
end
