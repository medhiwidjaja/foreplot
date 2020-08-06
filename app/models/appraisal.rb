class Appraisal < ApplicationRecord
  belongs_to :criterion
  belongs_to :member

  has_many :comparisons, dependent: :destroy
  has_many :direct_comparisons, dependent: :destroy
  has_many :ahp_comparisons, dependent: :destroy
  has_many :magiq_comparisons, dependent: :destroy

  validates :member, presence: true
  validates :appraisal_method, presence: true
  
  accepts_nested_attributes_for :direct_comparisons
  accepts_nested_attributes_for :magiq_comparisons
  accepts_nested_attributes_for :ahp_comparisons

  def find_or_initialize(comparison_method)
    raise "Unsupported comparisons: #{comparison_method}" unless [:direct_comparisons, :magiq_comparisons, :pairwise_comparisons].include? comparison_method
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

  private
end
