FactoryBot.define do
  factory :appraisal do
    criterion 
    member 
    is_valid      { true }
    is_complete   { true }
    appraisal_method  { "DirectComparison" }
    
    trait :with_direct_comparisons do
      appraisal_method  { "DirectComparison" }
      after :create do |appraisal|
        3.times do |i|
          appraisal.direct_comparisons << build(:direct_comparisons)
        end
      end
    end
  end
end
