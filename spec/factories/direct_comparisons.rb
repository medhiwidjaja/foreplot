FactoryBot.define do
  factory :direct_comparison do
    title { "Title" }
    notes { "MyString" }
    score { "9.99" }
    score_n { "9.99" }
    comparison_method { "SMART" }
    value { "1.0" }
    unit { "unit" }
    comparable
    comparable_type { "Class" }
  end
end