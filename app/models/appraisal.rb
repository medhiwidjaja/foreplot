class Appraisal < ApplicationRecord
  belongs_to :criterion
  belongs_to :member

  has_many :comparisons, dependent: :destroy
  has_many :direct_comparisons, dependent: :destroy
  has_many :ahp_comparisons, dependent: :destroy
  has_many :magiq_comparisons, dependent: :destroy
end
