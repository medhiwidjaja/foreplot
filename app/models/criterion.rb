class Criterion < ApplicationRecord
  belongs_to :article
  belongs_to :parent, class_name: 'Criterion', optional: true
  has_many :children, class_name: 'Criterion', foreign_key: :parent_id, dependent: :destroy
  has_many :comparisons, as: :comparable, dependent: :destroy
  has_many :direct_comparisons, as: :comparable, dependent: :destroy
  has_many :ahp_comparisons, as: :comparable, dependent: :destroy
  has_many :magiq_comparisons, as: :comparable, dependent: :destroy
  has_many :appraisals, dependent: :destroy
  
  validates :title, presence: true, uniqueness: {scope: [:article_id]}
  validates :position, uniqueness: {scope: [:article_id, :parent_id]}

  before_create  :assign_position_number
  after_save     :sync_position_with_comparisons, if: :saved_change_to_position?
  before_destroy :check_if_root

  scope :with_appraisals_by, ->(member_id) {
    joins(<<-SQL.squish
      LEFT OUTER JOIN appraisals a 
      ON a.criterion_id = criteria.id 
      AND a.member_id = #{ActiveRecord::Base.connection.quote(member_id)}
    SQL
    ).select('a.is_complete as is_complete')
  }

  scope :with_children, -> {
    joins(<<-SQL.squish
      LEFT OUTER JOIN (
        SELECT DISTINCT parent_id as id, array_agg(id) OVER (PARTITION BY parent_id) AS children 
        FROM criteria 
      ) pc USING(id)
    SQL
    ).select('criteria.*, children as subnodes')
    .order(:id)
  }

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

  # Called when creating new 
  def destroy_related_appraisals
    appraisals.destroy_all
  end

  private

  def must_have_parent_if_not_root
    if parent_id.blank? && article.criteria.root != self
      errors.add(:parent_id, "can't be blank")
    end
  end

  def assign_position_number
    unless parent.blank?
      if parent.children.exists?
        self.position = 1 + parent.children.maximum(:position)
      else 
        self.position = 1
      end
    end
  end

  def sync_position_with_comparisons
    comparisons.update_all position: position
  end

  def check_if_root
    errors.add(:base, "Cannot delete top level criterion") if parent_id.nil?
    throw(:abort) if errors.present?
  end

end
