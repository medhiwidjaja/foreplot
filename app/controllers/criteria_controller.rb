class CriteriaController < ApplicationController
  include TurbolinksCacheControl

  before_action :set_criterion, only: [:show, :new, :edit, :update, :destroy]
  before_action :set_presenter

  # GET /article/1/criteria
  # GET /article/1/criteria.json
  def index
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
  end

  def tree
    respond_to do |format|
      format.json { render 'tree', locals: {node: @presenter.tree}}
    end
  end

  # GET /criteria/1/edit
  def edit
  end

  # POST /criteria/1
  # POST /criteria/1.json
  def create
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
    @presenter ||= CriterionPresenter.new @criterion, params, current_user
  end

  # Only allow a list of trusted parameters through.
  def criterion_params
    params.require(:criterion).permit(:title, :description, :abbrev, :position, :appraisal_method, :comparison_type, :parent_id, :article_id)
  end
end