class DirectComparisonsController < ApplicationController

  before_action :set_criterion
  before_action :set_related_article
  before_action :set_member
  before_action :set_appraisal
  before_action :set_tree, only: [:new, :index, :edit]

  def new
    @form = DirectComparisonsForm.new @appraisal
  end

  def edit
    @form = DirectComparisonsForm.new @appraisal
  end

  def create
    @form = DirectComparisonsForm.new @appraisal, direct_comparisons_form_params
    if @form.submit
      redirect_to @criterion, notice: 'Direct comparisons saved'
    else
      flash[:error] = @form.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
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
      @appraisal = @criterion.appraisals.find_or_initialize_by member: @member, appraisal_method: 'DirectComparison'
    end

    def direct_comparisons_form_params
      params.require(:direct_comparisons_form).permit(:criterion_id, :member_id, :appraisal_method,
        {direct_comparisons_attributes: 
          [:id, :comparable_id, :comparable_type, :title, :notes, :comparison_method, :value, :unit, :appraisal_id,
           :score, :score_n, :rank]
        })
    end
end
