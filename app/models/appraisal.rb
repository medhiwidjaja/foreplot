class Appraisal < ApplicationRecord
  belongs_to :criterion
  belongs_to :member

  has_many :comparisons, dependent: :destroy
  has_many :direct_comparisons, dependent: :destroy
  has_many :ahp_comparisons, dependent: :destroy
  has_many :magiq_comparisons, dependent: :destroy
  has_many :pairwise_comparisons, dependent: :destroy

  validates :member, presence: true
  validates :appraisal_method, presence: true
  validates :appraisal_method, inclusion: { in: %w(DirectComparison MagiqComparison AHPComparison),
    message: "%{value} is not a valid comparison method" }
  validates :criterion_id, uniqueness: {scope: [:member_id]}
  validates :rank_method, presence: true, if: -> { appraisal_method == 'MagiqComparison' }
  validate  :unintermittency, if: -> { appraisal_method == 'MagiqComparison' }
  validates :pairwise_comparisons, presence: true, if: -> { ahp_comparisons.present? }

  accepts_nested_attributes_for :direct_comparisons
  accepts_nested_attributes_for :magiq_comparisons
  accepts_nested_attributes_for :ahp_comparisons

  scope :by, -> (member_id) { where(member_id: member_id) }
  
  COMPARISON_TYPES = [:direct_comparisons, :magiq_comparisons, :ahp_comparisons].freeze

  def find_or_initialize(comparison_method)
    raise "Unsupported comparisons: #{comparison_method}" unless COMPARISON_TYPES.include? comparison_method
    if comparison_method == :pairwise_comparisons
      comparisons = find_or_initialize_pairwise_comparisons
    else
      comparisons = self.public_send("#{comparison_method.to_s}")
      criterion.evaluatees.each do |evaluatee|
        comparisons.find_or_initialize_by comparable: evaluatee, title: evaluatee.title, appraisal: self
      end if comparisons.size == 0
    end
    comparisons
  end

  def find_or_initialize_pairwise_comparisons
  end

  def relevant_comparisons
    raise "Appraisal method missing" if appraisal_method.blank?
    send appraisal_method.pluralize.underscore
  end

  private

  def unintermittency
    rank_sequence = magiq_comparisons.collect(&:rank).uniq.sort
    check = (1..rank_sequence.size).to_a
    indexes = (1..magiq_comparisons.size).to_a
    empty_slots = indexes - rank_sequence 
    if rank_sequence != check
      message = "#{'Slot'.pluralize(empty_slots.size)} #{empty_slots.join(', ')} can't be empty"
      errors.add(:base, message)
      throw(:abort)
    end
  end
end
