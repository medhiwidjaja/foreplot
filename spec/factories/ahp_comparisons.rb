FactoryBot.define do
  factory :ahp_comparison do
    title           { "Title" }
    notes           { "MyString" }
    consistency     { "0.2" }
    score           { "0.99" }
    score_n         { "0.99" }
    comparable      factory: :criterion
    position        { 1 }
  end
end