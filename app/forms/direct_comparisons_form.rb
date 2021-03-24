class DirectComparisonsForm < ComparisonFormBase 
  attr_accessor :direct_comparisons_attributes, :criterion_id, :member_id, :appraisal_method
  attr_reader :comparable_type, :comparisons
  
  delegate :direct_comparisons, :range_min, :range_max, :minimize, :range_min=, :range_max=, :minimize=, to: :appraisal

  validates :appraisal, :member_id, :appraisal_method, :criterion_id, presence: true

  APPRAISAL_METHOD = 'DirectComparison'

  def initialize(appraisal, params = {})
    super(appraisal, params)
    @appraisal_method = APPRAISAL_METHOD
    @member_id = @appraisal.member_id
    @criterion_id = @appraisal.criterion_id
    @models = [@appraisal]  # required for validate_models
    @appraisal.find_or_initialize(:direct_comparisons)
    @comparisons = @appraisal.direct_comparisons.sort_by {|c| c.position}
    @criterion = Criterion.find @criterion_id
    @comparable_type = comparable(@criterion)
  end

  def submit
    appraisal.direct_comparisons.clear unless persisted?
    appraisal.attributes = appraisal_params
    if invalid?
      @comparisons = @appraisal.direct_comparisons.sort_by {|c| c.position}
      return false 
    end
    appraisal.save
    true
  end

  private

  def appraisal_params
    {
      criterion_id: criterion_id,
      member_id: member_id,
      appraisal_method: APPRAISAL_METHOD,
      comparable_type: @comparable_type,
      is_complete: true,
      minimize: minimize,
      range_min: range_min,
      range_max: range_max, 
      direct_comparisons_attributes: update_with_scores(direct_comparisons_attributes)
    }
  end

  def update_with_scores(attributes)
    options = { 
      range_min: range_min.blank? ? nil : range_min.to_f, 
      range_max: range_max.blank? ? nil : range_max.to_f, 
      minimize:  minimize 
    } 
    DirectComparisonCalculator.new(attributes, **options).call
  end

  def persisted?
    appraisal.direct_comparisons.any? &:persisted?
  end

end