class Comparison < ApplicationRecord
  belongs_to :comparable, polymorphic:true
  belongs_to :appraisal

  validates :type, presence: true
  validates :comparable_id, presence: true, uniqueness: { scope: [:appraisal_id, :type]}

end
