FactoryBot.define do
  factory :appraisal do
    criterion 
    member 
    appraisal_method  { "DirectComparison" }
    comparable_type  { "Criterion" }
    is_complete { true }
  end
end
