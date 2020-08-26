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
  validate :must_have_parent_if_not_root

  scope :includes_appraisals_by, ->(member_id) {
    includes(:appraisals, children: {children: [{children: [{children: [:children, :appraisals]}, :appraisals]}, :appraisals]})
      .where(appraisals: {member_id: member_id})
  }

  scope :includes_family, -> {
    includes(:parent, children: {children: {children: {children: {children: :children}}}})
  }

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

  private

  def must_have_parent_if_not_root
    if parent_id.blank? && Criterion.where(article_id:article_id).root.present?
      errors.add(:parent_id, "can't be blank")
    end
  end

end
