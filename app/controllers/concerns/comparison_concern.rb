module ComparisonConcern 
  extend ActiveSupport::Concern

  included do
    before_action :set_criterion
    before_action :set_related_article
    before_action :set_member
    before_action :set_appraisal
  end

  private

  def set_criterion
    @criterion = Criterion.find(params[:criterion_id])
  end

  def set_related_article
    @article = @criterion.article
  end

  def set_member
    @member = if params[:member_id] 
                @article.members.where(id: params[:member_id]).take
              else
                @article.members.where(user: current_user).take
              end
  end

  def set_appraisal
    @appraisal = @criterion.appraisals.find_or_initialize_by member: @member
  end
end 