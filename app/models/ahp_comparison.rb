
class AHPComparison < Comparison
  has_many :pairwise_comparisons, dependent: :destroy
end