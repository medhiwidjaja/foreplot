FactoryBot.define do
  factory :comparison do
    comparable_id { 1 }
    comparable_type { "MyString" }
    title { "MyString" }
    notes { "MyString" }
    score { "9.99" }
    score_n { "9.99" }
    comparison_method { "MyString" }
    value { "9.99" }
    unit { "MyString" }
    rank_no { 1 }
    rank_method { "MyString" }
    consistency { "9.99" }
  end
end
