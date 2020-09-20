class AHPComparisonsForm < ComparisonFormBase
  attr_reader :choices, :comparable_type
  attr_accessor :ahp_comparisons_form, :ahp_comparisons_attributes, :pairwise_comparisons_attributes,
                :criterion_id, :member_id, :appraisal_method, :notes, :choices

  delegate :ahp_comparisons, :pairwise_comparisons, to: :appraisal

  validates :appraisal, :member_id, :appraisal_method, :criterion_id, presence: true

  APPRAISAL_METHOD = 'AHPComparison'

  def initialize(appraisal, params = {})
    super(appraisal, params)
    @appraisal_method = APPRAISAL_METHOD
    @member_id = @appraisal.member_id
    @criterion_id = @appraisal.criterion_id
    @criterion = Criterion.find @criterion_id
    @models = [@appraisal]  # required for validate_models
    @appraisal.find_or_initialize :ahp_comparisons
    @appraisal.find_or_initialize_pairwise_comparisons
    @choices = get_choices(@appraisal)
    @comparable_type = comparable(@criterion)
  end

  def submit
    appraisal.ahp_comparisons.clear unless persisted?
    appraisal.pairwise_comparisons.clear unless persisted?   
    calculator = AHPComparisonCalculator.new(pairwise_comparisons_attributes, choices)
    appraisal.attributes = appraisal_params(calculator)
    return false if invalid?
    appraisal.save
    true
  end

  def num_comparisons
    ahp_comparisons.size
  end

  private

  def appraisal_params(calculator)
    {
      criterion_id: criterion_id,
      member_id: member_id,
      appraisal_method: APPRAISAL_METHOD,
      consistency_ratio: calculator.cr,
      is_complete: true,
      comparable_type: @comparable_type,
      ahp_comparisons_attributes: calculator.call,
      pairwise_comparisons_attributes: pairwise_comparisons_attributes
    }
  end

  def persisted?
    @persisted ||= appraisal.ahp_comparisons.any? &:persisted?
  end

  def get_choices(appraisal)
    appraisal.ahp_comparisons.map {|c| 
      {id: c.id, comparable_id: c.comparable_id, comparable_type: c.comparable_type, position: c.position, name: c.title }
    }
    .sort {|h| h[:position]}.reverse
  end

end