FactoryBot.define do
  factory :direct_comparison do
    title { "Title" }
    notes { "MyString" }
    score { "9.99" }
    score_n { "9.99" }
    comparison_method { "direct" }
    value { "1.0" }
    unit { "unit" }
    comparable  factory: :criterion
    comparable_type { "Criterion" }
  end
end