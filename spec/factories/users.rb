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
    end

    factory :bingley do
      name     { 'Mr Bingley' }
      email    { 'bingley@netherfield.com' }
      account  { 'basic' }
    end

    factory :jane do
      name     { 'Jane' }
      email    { 'jane@longbourn.net' }
      account  { 'free' }
    end
  end

end