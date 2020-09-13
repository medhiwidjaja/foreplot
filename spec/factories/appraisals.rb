FactoryBot.define do
  factory :appraisal do
    criterion 
    member 
    appraisal_method  { "DirectComparison" }
    comparable_type  { "Criterion" }
  end
end
