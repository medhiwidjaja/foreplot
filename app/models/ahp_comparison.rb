class AHPComparison < Comparison

  validates :position, presence: true

  scope :order_by_position, -> {
    order(position: :asc)
  }

end