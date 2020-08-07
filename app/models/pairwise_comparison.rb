class PairwiseComparison < ApplicationRecord
  belongs_to :comparable1, polymorphic:true
  belongs_to :comparable2, polymorphic:true
  belongs_to :ahp_comparison
  validates :value, presence: true
end
