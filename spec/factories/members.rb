FactoryBot.define do
  factory :member do
    article factory: :article 
    user    factory: :user 
    role    { "Editor" }
    active  { true }
  end
end
