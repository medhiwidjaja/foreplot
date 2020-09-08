FactoryBot.define do
  factory :appraisal do
    criterion 
    member 
    appraisal_method  { "DirectComparison" }
    
    trait :with_direct_comparisons do
      appraisal_method  { "DirectComparison" }
      after :create do |appraisal|
        3.times do |i|
          appraisal.direct_comparisons << build(:direct_comparisons)
        end
      end
    end

    trait :with_magiq_comparisons do
      appraisal_method { "MagiqComparison" }
      rank_method { "rank_order_centroid" }
      after :create do |appraisal|
        3.times do |i|
          appraisal.magiq_comparisons << build(:magiq_comparisons)
        end
      end
    end
  end
end
