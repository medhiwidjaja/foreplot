FactoryBot.define do
  factory :alternative do
    sequence(:title)    { |n| "Alternative #{n}" }
    description         { "This is an alternative" }
    sequence(:abbrev)   { |n| "Alt #{n}" }
    sequence(:position) { |n| n }
    article             factory: :article 
  end
end
