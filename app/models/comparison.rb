class Comparison < ApplicationRecord
  belongs_to :comparable, polymorphic:true
  belongs_to :appraisal

  validates :appraisal_id, presence: true, uniqueness: { scope: [:comparable_id, :type]}
end
