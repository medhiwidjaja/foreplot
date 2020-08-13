
class MagiqComparisonsController < ApplicationController

  before_action :set_criterion
  before_action :set_related_article
  before_action :set_member
  before_action :set_appraisal
  before_action :set_tree, only: [:new, :index, :edit]

  def new
    @form = MagiqComparisonsForm.new @appraisal
  end

  def edit
    @form = MagiqComparisonsForm.new @appraisal
  end

  def create
    @form = MagiqComparisonsForm.new @appraisal, magiq_comparisons_form_params
    if @form.submit
      redirect_to @criterion, notice: 'Magiq comparisons saved'
    else
      flash[:error] = @form.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @form = MagiqComparisonsForm.new @appraisal, magiq_comparisons_form_params
    if @form.submit
      redirect_to @criterion, notice: 'Magiq comparisons updated'
    else
      flash[:error] = @form.errors.full_messages.to_sentence
      render :edit
    end
  end

  private
    def set_criterion
      @criterion = Criterion.find(params[:criterion_id])
    end

    def set_related_article
      @article = @criterion.article
    end

    def set_tree
      @tree = @article.criteria.root.to_tree
    end

    def set_member
      @member = if params[:member_id] 
                  @article.members.where(id: params[:member_id]).take
                else
                  @article.members.where(user: current_user).take
                end
    end

    def set_appraisal
      @appraisal = @criterion.appraisals.find_or_initialize_by member: @member, appraisal_method: 'MagiqComparison'
    end

    def magiq_comparisons_form_params
      params.require(:magiq_comparisons_form).permit(:criterion_id, :member_id, :appraisal_method, :rank_method,
        {magiq_comparisons_attributes: 
          [:id, :comparable_id, :comparable_type, :title, :notes, :comparison_method, :appraisal_id,
           :score, :score_n, :rank]
        })
    end
end
