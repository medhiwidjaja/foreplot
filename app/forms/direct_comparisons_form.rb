class DirectComparisonsForm
  include ActiveModel::Model 

  attr_reader :appraisal, :comparisons
  attr_accessor :direct_comparisons_attributes

  validate :appraisal_is_valid, :comparisons_are_valid

  delegate :direct_comparisons, to: :appraisal

  def initialize(appraisal, params = {})
    @appraisal = appraisal
    @criterion = @appraisal.criterion
    super(params)
    @comparisons = @appraisal.find_or_initialize(:direct_comparisons)
  end

  def submit
    direct_comparisons_attributes = DirectComparisonCalculatorService.new.call(comparisons)
    @appraisal.attributes = appraisal_params
    return false if invalid?
    @appraisal.save
    true
  end

  private

  def appraisal_params
    {
      criterion_id: @criterion.id,
      member_id: @appraisal.member.id,
      appraisal_method: 'DirectComparison',
      direct_comparisons_attributes: direct_comparisons_attributes
    }
  end
  
  def appraisal_is_valid
    errors.add(:appraisal, 'is invalid') if appraisal.invalid?
  end

  def comparisons_are_valid
    errors.add(:direct_comparisons, 'are invalid') if direct_comparisons.any?(&:invalid?)
  end

end