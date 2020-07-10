class DirectComparison < Comparison
  belongs_to :comparable, polymorphic:true
  validates :value, presence: true
end
