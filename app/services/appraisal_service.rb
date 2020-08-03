class AppraisalService
  attr_reader :criterion, :appraisal, :appraisal_method

  def initialize(criterion, comparison_method, member_id)
    @criterion = criterion
    @appraisal_method = comparison_method.to_s
    @appraisal = Appraisal.find_or_initialize_by criterion_id: @criterion.id
    @appraisal.appraisal_method = @appraisal_method
    @appraisal.member_id = member_id
  end

  def get_template
    appraisal.appraisal_method.to_s
  end

  def get_comparisons
    comparison_method_str = "#{appraisal_method.to_s}_comparisons"
    comparisons = appraisal.public_send(comparison_method_str)
    criterion.evaluatees.each do |evaluatee|
      comparisons.find_or_initialize_by comparable: evaluatee, title: evaluatee.title
    end if comparisons.size == 0
    comparisons
  end

end