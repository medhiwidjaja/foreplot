FactoryBot.define do
  factory :article do
    sequence(:title)  { |n| "Article #{n}" }
    description { 'Description' }
    likes { '1' }
    slug  { 'article-title' }
    active { true }
    private { false }
    user  factory: :user
  end

end