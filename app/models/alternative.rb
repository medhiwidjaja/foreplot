class Alternative < ApplicationRecord
  belongs_to :article
  has_many :properties
  has_many :rankings
  has_many :comparisons, as: :comparable, dependent: :destroy
  has_many :direct_comparisons, as: :comparable, dependent: :destroy
  has_many :ahp_comparisons, as: :comparable, dependent: :destroy
  has_many :magiq_comparisons, as: :comparable, dependent: :destroy
  validates :title, presence: true
  
end
