
class AhpComparison < Comparison
  belongs_to :comparable, polymorphic:true
  has_many :pairwise_comparisons
end