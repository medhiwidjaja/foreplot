class CriteriaController < ApplicationController
  include TurbolinksCacheControl

  before_action :set_criterion, except: [:index, :new, :create, :tree]
  before_action :set_presenter, except: [:index, :new, :tree]

  # GET /article/1/criteria
  # GET /article/1/criteria.json
  def index
    @article = Article.with_criteria.find params[:article_id]
    @presenter = CriterionPresenter.new @article.criteria.root, current_user, {member_id: params[:member_id]}
  end

  # GET /criteria/1
  # GET /criteria/1.json
  def show
    respond_to do |format|
      format.html 
      format.js 
    end
  end

  # GET /criteria/1/new
  def new
    @parent = Criterion.find(params[:id])
    @criterion = Criterion.new parent: @parent, article:@parent.article
    @presenter = CriterionPresenter.new @criterion, current_user, {member_id: params[:member_id]}
  end

  def tree
    member_id = params[:p] 
    root = Criterion.find(params[:id])
    tree = Criteria::Tree.new(root.article_id, member_id)
    respond_to do |format|     
      format.json { render json: tree.as_json_tree(root.id) }
    end
  end

  # GET /criteria/1/edit
  def edit
  end

  # POST /criteria/1
  # POST /criteria/1.json
  def create
    @criterion = Criterion.new criterion_params
    if @criterion.save
      @criterion.parent.destroy_related_appraisals
      redirect_to @criterion, notice: 'Criterion was successfully created.'
    else
      @parent = Criterion.find(params[:id])
      @criterion.parent = @parent
      @presenter = CriterionPresenter.new @criterion, current_user
      render :new
    end
  end

  # PATCH/PUT /criteria/1
  # PATCH/PUT /criteria/1.json
  def update
    if @criterion.update(criterion_params)
      redirect_to @criterion, notice: 'Criterion was successfully updated.'
    else
      render :edit, alert: @criterion.errors
    end
  end

  # DELETE /criteria/1
  # DELETE /criteria/1.json
  def destroy
    @parent = @criterion.parent
    @article = @criterion.article
    if @criterion.destroy
      @parent.destroy_related_appraisals unless @parent.nil?
      redirect_to article_criteria_path(@article), notice: 'Criterion was successfully destroyed.'
    else
      flash[:error] = @criterion.errors.full_messages.to_sentence
      redirect_to article_criteria_path(@article)
    end
  end

  # TODO: Handle move criterion requests (from criteria_tree.js)

  private

  def set_criterion
    @criterion = Criterion.includes(:appraisals).find(params[:id])
  end

  def set_presenter
    @presenter = CriterionPresenter.new @criterion, current_user, {member_id: params[:member_id], article_id: params[:article_id]}
  end

  # Only allow a list of trusted parameters through.
  def criterion_params
    params.require(:criterion).permit(:title, :description, :abbrev, :position, :appraisal_method, :comparison_type, :parent_id, :article_id)
  end
end