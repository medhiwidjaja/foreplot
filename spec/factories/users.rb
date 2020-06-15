FactoryBot.define do
  factory :user do
    sequence(:name)  { |n| "Guest #{n}" }
    sequence(:email) { |n| "guest_#{n}@meryton.net" }
    password { "pride&prejudice" }
    password_confirmation { "pride&prejudice" }
    
    factory :darcy do
      name     { 'Mr Darcy' }
      email    { 'darcy@pemberly.com' }
      account  { 'pro' }
      
      trait :with_articles do
        after :create do |user|
          create(:article, title: "Darcy's article", user: user)
        end
      end 
    end

    factory :bingley do
      name     { 'Mr Bingley' }
      email    { 'bingley@netherfield.com' }
      account  { 'basic' }

      trait :with_articles do
        after :create do |user|
          create(:article, title: "Bingley's article", user: user)
        end
      end 
    end

    factory :jane do
      name     { 'Jane' }
      email    { 'jane@longbourn.net' }
      account  { 'free' }
    end
  end

end