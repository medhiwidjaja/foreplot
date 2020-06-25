FactoryBot.define do
  factory :ranking do
    article { nil }
    vote { nil }
    type { "MyString" }
    alternative { nil }
    score { "9.99" }
    rank_no { 1 }
    notes { "MyString" }
  end
end
