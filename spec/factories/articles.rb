FactoryBot.define do
  factory :article do
    sequence(:title)  { |n| "Some article #{n}" }
    user  factory: :user
  end

end