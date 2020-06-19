FactoryBot.define do
  factory :property do
    name { "MyString" }
    value { "9.99" }
    unit { "MyString" }
    is_cost { false }
    is_common { false }
    description { "MyString" }
    article
    alternative
  end
end
