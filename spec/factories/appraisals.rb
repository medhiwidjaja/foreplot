FactoryBot.define do
  factory :appraisal do
    criterion 
    member 
    is_valid      { true }
    appraisal_method  { "Direct" }
    is_complete   { true }
  end
end
