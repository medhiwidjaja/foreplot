FactoryBot.define do
  factory :vote do
    article { nil }
    user { nil }
    member { nil }
    weight { "9.99" }
    weight_n { "9.99" }
  end
end
