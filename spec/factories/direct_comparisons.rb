FactoryBot.define do
  factory :direct_comparison do
    title { "Title" }
    notes { "MyString" }
    score { "0.40" }
    score_n { "0.40" }
    comparison_method { "DirectComparison" }
    value { "4.0" }
    unit { "unit" }
    comparable  factory: :criterion
    position        { 1 }
  end
end