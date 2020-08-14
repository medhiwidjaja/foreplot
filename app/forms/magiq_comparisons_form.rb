class MagiqComparisonsForm < BaseForm
  attr_reader :appraisal
  attr_accessor :magiq_comparisons_form, :magiq_comparisons_attributes, :criterion_id, 
                :member_id, :appraisal_method, :rank_method, :notes

  delegate :magiq_comparisons, to: :appraisal

  validates :appraisal, :member_id, :appraisal_method, :criterion_id, presence: true

  APPRAISAL_METHOD = 'MagiqComparison'

  def initialize(appraisal, params = {})
    @appraisal = appraisal
    @appraisal_method = APPRAISAL_METHOD
    @member_id = @appraisal.member_id
    @criterion_id = @appraisal.criterion_id
    @models = [@appraisal]  # required for validate_models
    super(params)
    @appraisal.find_or_initialize :magiq_comparisons
  end

  def submit
    appraisal.magiq_comparisons.clear unless persisted?
    appraisal.attributes = appraisal_params
    return false if invalid?
    appraisal.save
    true
  end

  def rest_method
    appraisal.persisted? ? :patch : :post
  end

  def num_comparisons
    magiq_comparisons.size
  end

  private

  def appraisal_params
    {
      criterion_id: criterion_id,
      member_id: member_id,
      appraisal_method: APPRAISAL_METHOD,
      rank_method: rank_method,
      magiq_comparisons_attributes: update_with_scores(magiq_comparisons_attributes)
    }
  end

  def update_with_scores(attributes)
    MagiqComparisonCalculatorService.new(attributes, rank_method).call
  end

  def persisted?
    appraisal.magiq_comparisons.any? &:persisted?
  end

end