class PairwiseComparison < ApplicationRecord
  belongs_to :comparable1, polymorphic:true
  belongs_to :comparable2, polymorphic:true
  belongs_to :appraisal
  validates :appraisal, presence: true
  validates :value, presence: true
end
