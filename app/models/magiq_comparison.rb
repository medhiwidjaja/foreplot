class MagiqComparison < Comparison
  belongs_to :comparable, polymorphic:true
  validates :rank_no, :rank_method, presence: true
end