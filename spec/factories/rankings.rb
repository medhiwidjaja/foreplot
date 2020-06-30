FactoryBot.define do
  factory :ranking do
    article     factory: :article 
    vote        factory: :vote 
    alternative factory: :alternative 
    type        { "Comparison" }
    score       { "9.99" }
    rank_no     { 1 }
    notes       { "My notes" }
  end
end
