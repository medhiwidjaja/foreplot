FactoryBot.define do
  factory :appraisal do
    criterion 
    member 
    appraisal_method  { "DirectComparison" }
    comparable_type  { "Criterion" }
    is_complete { true }

    trait :with_direct_comparisons do
      after :create do
        criterion.children << [build(:criterion), build(:criterion)]
        appraisal.direct_comparisons << [
          build(:direct_comparison, value: 1, comparable: criterion.children.first),
          build(:direct_comparison, value: 2, comparable: criterion.children.last)
        ]
      end
    end
  end
end
