FactoryBot.define do
  factory :comparison do
    title { "MyString" }
    notes { "MyString" }
    score { 0.99 }
    score_n { 0.19 }
    comparable  factory: :criterion

    trait :direct_comparison do
      comparison_method { "DirectComparison" }
      value { 9.99 }
      unit { "unit" }
    end

    trait :magiq_comparison do
      comparison_method { "MagiqComparison" }
      rank { 1 }
    end

    trait :pairwise_comparison do
      comparison_method { "PairwiseComparison" }
      consistency { 0.2 }
    end
  end
end
