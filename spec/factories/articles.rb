FactoryBot.define do
  factory :article do
    sequence(:title)  { |n| "Article #{n}" }
    description { 'Description' }
    likes { '1' }
    slug  { 'article-title' }
    active { true }
    user  factory: :user

    trait :public do
      private { false }
    end

    trait :private do
      private { true }
    end
  end

end