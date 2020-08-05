class AppraisalsController < ApplicationController
  include TurbolinksCacheControl
  
  before_action :set_criterion, only: [:direct, :rank, :pairwise, :create]
  before_action :set_appraisal, only: [:update, :destroy]
  before_action :set_tree, only: [:direct, :rank, :pairwise]

  def direct
    @appraisal = appraisal_service.appraisal
    @direct_comparisons = appraisal_service.get_comparisons
  end

  def rank
  end

  def pairwise
  end

  def show
  end

  def create 
    @appraisal = Appraisal.new(appraisal_params)
    respond_to do |format|
      if @appraisal.save
        format.html { redirect_to @appraisal, notice: 'Appraisal was successfully created.' }
        format.json { render :show, status: :created, location: @appraisal }
      else
        format.html { render appraisal_service.get_template }
        format.json { render json: @appraisal.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  def destroy
  end

  private

    def set_appraisal
      @appraisal = Appraisal.find(params[:id])
    end

    def set_criterion
      @criterion = Criterion.find(params[:criterion_id])
      @article = @criterion.article
      @member = @article.members.find_by user:current_user
    end

    def set_tree
      @tree = @article.criteria.root.to_tree
    end

    def appraisal_service
      comparison_method = @appraisal.nil? ? action_name : @appraisal.appraisal_method
      @appraisal_service ||= AppraisalService.new(@criterion, comparison_method, @member.id)
    end
    
    def appraisal_params
      params.require(:appraisal).permit(:is_complete, :is_valid, :member_id, :criterion_id, :appraisal_method,
        comparisons_attributes: [
          :id, :comparable_id, :comparable_type, :title, :notes, :score, :score_n, :comparison_method, 
          :value, :unit, :rank_no, :rank_method, :consistency, :type, :appraisal_id
        ]
      )
    end
end
