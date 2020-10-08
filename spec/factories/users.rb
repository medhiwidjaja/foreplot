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

    factory :guest_user do
      name     { "Guest user" }
      account  { 'free' }
      role     { 'guest' }
    end

    trait :with_free_account do
      account  { 'free' }
      role     { 'member' }
    end

    trait :with_basic_account do
      account  { 'basic' }
      role     { 'member' }
    end

    trait :with_academic_account do
      account  { 'academic' }
      role     { 'member' }
    end

    trait :with_pro_account do
      account  { 'pro' }
      role     { 'member' }
    end
  end

end