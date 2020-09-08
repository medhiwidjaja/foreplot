class PairwiseComparison < ApplicationRecord
  belongs_to :comparable1, polymorphic:true
  belongs_to :comparable2, polymorphic:true
  belongs_to :appraisal

  validates :value, presence: true
  validates :appraisal, presence: true

  default_scope { order(:comparable1_id, :comparable2_id) }
end
