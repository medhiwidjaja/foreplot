class DirectComparisonsForm
  include ActiveModel::Model 

  attr_reader :appraisal, :comparisons
  attr_accessor :direct_comparisons_attributes, :criterion_id, :member_id, :appraisal_method

  validate :appraisal_is_valid, :comparisons_are_valid

  delegate :direct_comparisons, to: :appraisal

  def initialize(appraisal, params = {})
    @appraisal = appraisal
    @comparisons = @appraisal.find_or_initialize(:direct_comparisons)
    @appraisal_method = 'DirectComparison'
    @member_id = @appraisal.member_id
    @criterion_id = @appraisal.criterion_id
    super(params)
  end

  def submit
    puts appraisal_params
    appraisal.direct_comparisons.clear
    appraisal.attributes = appraisal_params
    puts appraisal.attributes
    return false if invalid?
    appraisal.save
    true
  end

  private

  def appraisal_params
    {
      criterion_id: criterion_id,
      member_id: member_id,
      appraisal_method: 'DirectComparison',
      direct_comparisons_attributes: DirectComparisonCalculatorService.new(direct_comparisons_attributes).call
    }
  end
  
  def appraisal_is_valid
    errors.add(:appraisal, 'is invalid') if appraisal.invalid?
    appraisal.valid?
  end

  def comparisons_are_valid
    errors.add(:direct_comparisons, 'are invalid') if direct_comparisons.any?(&:invalid?)
    direct_comparisons.any?(&:invalid?) ? false : true
  end

end