FactoryBot.define do
  factory :pairwise_comparison do
    comparable1      factory: :criterion
    comparable1_type { "Criterion" }
    comparable2      factory: :criterion
    comparable2_type { "Criterion" }
    appraisal        factory: :appraisal
    value            { 0.25 }
  end
end