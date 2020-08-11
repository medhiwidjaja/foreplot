FactoryBot.define do
  factory :criterion do
    sequence(:title)       { |n| "Criterion #{n}" }
    sequence(:abbrev)      { |n| "C##{n}" }
    sequence(:description) { |n| "This is criterion #{n}" }
    cost                   { false }
    active                 { true }
    comparison_type        { 1 }
    appraisal_method       { 'direct' }
    property_name          { "Property Link" }
    sequence(:position)    { |n| n }

    trait :with_3_children do
      after :create do |criterion|
        3.times do |i|
          create :criterion, title: "Child ##{i+1}", parent: criterion
        end
      end
    end 

    trait :with_appraisal do
      after :create do |criterion|
        criterion.appraisals << create(:appraisal)
      end
    end
  end
end
