FactoryBot.define do
  factory :vote do
    article   factory: :article 
    user      factory: :user
    member    factory: :member
    weight    { "9.9" }
    weight_n  { "0.2" }
  end
end
