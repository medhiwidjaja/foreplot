class Criterion < ApplicationRecord
  belongs_to :article
  belongs_to :parent, class_name: 'Criterion', optional: true
  has_many :children, class_name: 'Criterion', foreign_key: :parent_id
  has_many :comparisons, as: :comparable, dependent: :destroy
  has_many :direct_comparisons, as: :comparable, dependent: :destroy
  has_many :ahp_comparisons, as: :comparable, dependent: :destroy
  has_many :magiq_comparisons, as: :comparable, dependent: :destroy
  has_many :appraisals

  validates :title, presence: true

  def to_tree
    Criteria::Tree.build_tree(Criterion.includes(:parent, children: {children: :children}).find(self.id)) {|c| c.attributes.slice("id","title") }
  end

  def self.root
    where(parent:nil).take
  end

  def root?
    parent_id.blank?
  end

  def leaf?
    children.empty?
  end

  def evaluatees
    if leaf?
      article.alternatives
    else
      children
    end
  end

  # def comparison_method
  #   appraisal_method || (appraisal ? appraisal.appraisal_method : nil)
  # end
end
