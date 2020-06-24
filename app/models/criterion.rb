class Criterion < ApplicationRecord
  belongs_to :article
  belongs_to :parent, class_name: 'Criterion', optional: true
  has_many :children, class_name: 'Criterion', foreign_key: :parent_id

  validates :title, presence: true

  scope :root, -> { where parent:nil }

  def to_tree
    Criteria::Tree.build_tree(self) {|c| c.attributes.slice("id","title") }
  end

  def root?
    parent_id.blank?
  end

end
