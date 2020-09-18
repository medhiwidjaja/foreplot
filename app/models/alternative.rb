class Alternative < ApplicationRecord
  belongs_to :article
  has_many :properties
  has_many :rankings
  has_many :comparisons, as: :comparable, dependent: :destroy
  has_many :direct_comparisons, as: :comparable, dependent: :destroy
  has_many :ahp_comparisons, as: :comparable, dependent: :destroy
  has_many :magiq_comparisons, as: :comparable, dependent: :destroy
  
  validates :title, presence: true

  before_create :assign_position_number
  after_save :sync_position_with_ahp_comparisons, if: :saved_change_to_position?

  scope :order_by_position, -> { order(:position) }

  private

  def assign_position_number
    if article.alternatives.exists?
      self.position = 1 + article.alternatives.maximum(:position)
    else 
      self.position = 1
    end
  end

  def sync_position_with_ahp_comparisons
    ahp_comparisons.update_all position: position
  end

end
