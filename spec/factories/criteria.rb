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

    trait :with_3_children do
      after :create do |criterion|
        3.times do |i|
          create :criterion, title: "Child ##{i+1}", parent: criterion
        end
      end
    end 

    trait :with_appraisal do
      after :create do |criterion|
        create :appraisal, criterion: criterion
      end
    end
  end
end
