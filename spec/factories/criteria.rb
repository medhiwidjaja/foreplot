FactoryBot.define do
  factory :criterion do
    sequence(:title)       { |n| "Criterion #{n}" }
    sequence(:abbrev)      { |n| "C##{n}" }
    sequence(:description) { |n| "This is criterion #{n}" }
    cost                   { false }
    active                 { true }
    comparison_type        { 1 }
    eval_method            { 1 }
    property_name          { "Property Link" }
    sequence(:position)    { |n| n }
    article                factory: :article 
  end
end
