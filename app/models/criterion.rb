class Criterion < ApplicationRecord
  belongs_to :article
  belongs_to :parent, class_name: 'Criterion', optional: true
  has_many :children, class_name: 'Criterion', foreign_key: :parent_id

  validates :title, presence: true

  def to_tree
    Criteria::Tree.build_tree(Criterion.includes(children: {children: :children}).find(self.id)) {|c| c.attributes.slice("id","title") }
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


end
