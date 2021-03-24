class AppraisalsController < ApplicationController

  # DELETE /appraisals/1
  # DELETE /appraisals/1.json
  def destroy
    appraisal = Appraisal.find params[:id]
    comparison_name = appraisal.comparison_name
    @criterion = appraisal.criterion
    authorize! :manage, @criterion.article
    @presenter = CriterionPresenter.new @criterion, current_user, member_id: appraisal.member_id, article_id: @criterion.article_id
    appraisal.destroy
    
    respond_to do |format|
      flash[:alert] = "All #{comparison_name.pluralize} related to this criterion have been deleted."
      format.js 
    end
  end
end