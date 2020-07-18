class AppraisalService
  attr_reader :criterion, :appraisal

  def initialize(criterion)
    @criterion = criterion
    @appraisal = Appraisal.find_or_initialize_by criterion_id: @criterion.id
  end

  def find_or_initialize
    appraisal
  end

  def direct_comparisons
    criterion.evaluatees.each do |evaluatee|
      appraisal.direct_comparisons.find_or_initialize_by comparable: evaluatee
    end
    appraisal.direct_comparisons
  end
end