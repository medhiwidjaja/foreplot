FactoryBot.define do
  factory :assay do
    criterion 
    member 
    is_valid      { true }
    assay_method  { "Direct" }
    is_complete   { true }
  end
end
