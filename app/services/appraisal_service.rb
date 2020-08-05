class AppraisalService
  attr_reader :criterion, :appraisal, :appraisal_method, :member

  def initialize(criterion, member_id, comparison_method=nil)
    @criterion = criterion
    @member = member_id ? Member.find(member_id) : current_user
    @appraisal = Appraisal.find_or_initialize_by criterion_id: criterion.id, member_id: @member.id
    @appraisal_method = @appraisal.appraisal_method || comparison_method
    raise 'appraisal_method cannot be nil' if @appraisal_method.nil?
  end


  def get_comparisons
    comparisons = appraisal.public_send(appraisal_method.pluralize.underscore)
    criterion.evaluatees.each do |evaluatee|
      comparisons.find_or_initialize_by comparable: evaluatee, title: evaluatee.title
    end if comparisons.size == 0
    comparisons
  end

end