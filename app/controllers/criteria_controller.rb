class CriteriaController < ApplicationController
  include TurbolinksCacheControl

  before_action :set_criterion, except: [:index, :new, :create]
  before_action :set_presenter, except: [:index, :new, :tree]

  # GET /article/1/criteria
  # GET /article/1/criteria.json
  def index
    @article = Article.find params[:article_id]
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
    respond_to do |format|
      format.json { render 'tree', locals: {node: @criterion.to_tree}}
    end
  end

  # GET /criteria/1/edit
  def edit
  end

  # POST /criteria/1
  # POST /criteria/1.json
  def create
    @criterion = Criterion.new criterion_params
    respond_to do |format|
      if @criterion.save
        format.html { redirect_to @criterion, notice: 'Criterion was successfully created.' }
        format.json { render :show, status: :created, location: @criterion }
      else
        format.html { render :new, alert: @criterion.errors }
        format.json { render json: @criterion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /criteria/1
  # PATCH/PUT /criteria/1.json
  def update
    respond_to do |format|
      if @criterion.update(criterion_params)
        format.html { redirect_to @criterion, notice: 'Criterion was successfully updated.' }
        format.json { render :show, status: :ok, location: @criterion }
      else
        format.html { render :edit }
        format.json { render json: @criterion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /criteria/1
  # DELETE /criteria/1.json
  def destroy
    @parent = @criterion.parent
    @criterion.destroy
    respond_to do |format|
      format.html { redirect_to @parent, notice: 'Criterion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_criterion
    @criterion = Criterion.find(params[:id])
  end

  def set_presenter
    @presenter = CriterionPresenter.new @criterion, current_user, {member_id: params[:member_id], article_id: params[:article_id]}
  end

  # Only allow a list of trusted parameters through.
  def criterion_params
    params.require(:criterion).permit(:title, :description, :abbrev, :position, :appraisal_method, :comparison_type, :parent_id, :article_id)
  end
end