class AHPComparisonsForm < BaseForm
  attr_reader :choices
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
    @models = [@appraisal]  # required for validate_models
    @appraisal.find_or_initialize :ahp_comparisons
    @appraisal.find_or_initialize_pairwise_comparisons
    @choices = get_choices(@appraisal)
  end

  def submit
    appraisal.ahp_comparisons.clear unless persisted?
    appraisal.pairwise_comparisons.clear unless persisted?
    appraisal.attributes = appraisal_params
    return false if invalid?
    appraisal.save
    true
  end

  def num_comparisons
    ahp_comparisons.size
  end

  private

  def appraisal_params
    {
      criterion_id: criterion_id,
      member_id: member_id,
      appraisal_method: APPRAISAL_METHOD,
      ahp_comparisons_attributes: update_with_scores(pairwise_comparisons_attributes, choices),
      pairwise_comparisons_attributes: pairwise_comparisons_attributes
    }
  end

  # FIXME: Slider value is zero based so offset is wrong
  # TODO:  Instead of storing the slider values in the database, we should store the real comparison values
  
  def update_with_scores(attributes, choices)
    AHPComparisonCalculator.new(attributes, choices).call
  end

  def persisted?
    @persisted ||= appraisal.ahp_comparisons.any? &:persisted?
  end

  def get_choices(appraisal)
    appraisal.ahp_comparisons.map {|c| {id: c.id, comparable_id: c.comparable_id, comparable_type: c.comparable_type, name: c.title }}
  end

end