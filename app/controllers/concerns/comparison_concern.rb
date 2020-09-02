module ComparisonConcern 
  extend ActiveSupport::Concern

  included do
    before_action :set_criterion
    before_action :set_presenter
    before_action :set_appraisal
  end

  private

  def set_criterion
    @criterion = Criterion.find(params[:criterion_id])
  end

  def set_presenter
    @presenter = CriterionPresenter.new @criterion, current_user, {member_id: params[:member_id]}
  end

  def set_appraisal
    appraisals_method = controller_name.classify
    @appraisal = @criterion.appraisals.where(appraisal_method: appraisals_method).find_or_initialize_by member: @member
  end
end 