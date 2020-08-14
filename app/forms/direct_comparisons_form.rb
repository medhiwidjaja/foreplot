class DirectComparisonsForm < BaseForm 
  attr_reader :appraisal, :rest_method
  attr_accessor :direct_comparisons_attributes, :criterion_id, :member_id, :appraisal_method

  delegate :direct_comparisons, to: :appraisal

  validates :appraisal, :member_id, :appraisal_method, :criterion_id, presence: true

  APPRAISAL_METHOD = 'DirectComparison'

  def initialize(appraisal, params = {})
    @appraisal = appraisal
    @appraisal_method = APPRAISAL_METHOD
    @member_id = @appraisal.member_id
    @criterion_id = @appraisal.criterion_id
    @models = [@appraisal]  # required for validate_models
    super(params)
    @appraisal.find_or_initialize :direct_comparisons
    @rest_method = @appraisal.persisted? ? :patch : :post
  end

  def submit
    appraisal.direct_comparisons.clear unless persisted?
    appraisal.attributes = appraisal_params
    return false if invalid?
    appraisal.save
    true
  end

  private

  def appraisal_params
    {
      criterion_id: criterion_id,
      member_id: member_id,
      appraisal_method: APPRAISAL_METHOD,
      direct_comparisons_attributes: update_with_scores(direct_comparisons_attributes)
    }
  end

  def update_with_scores(attributes)
    DirectComparisonCalculatorService.new(attributes).call
  end

  def persisted?
    appraisal.direct_comparisons.any? &:persisted?
  end

end