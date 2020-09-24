FactoryBot.define do
  factory :magiq_comparison do
    title { "Title" }
    notes { "MyString" }
    rank { "1" }
    score { "9.99" }
    score_n { "9.99" }
    comparable  factory: :criterion
    position        { 1 }
  end
end