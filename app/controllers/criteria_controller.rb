class CriteriaController < ApplicationController
  include TurbolinksCacheControl

  before_action :set_criterion, only: [:show, :edit, :update, :destroy]

  # GET /article/1/criteria
  # GET /article/1/criteria.json
  def index
    @article = Article.find params[:article_id]
    @criteria = @article.criteria.all.order(:position)
  end

  # GET /criteria/1
  # GET /criteria/1.json
  def show
    @article = @criterion.article
    @criteria = @article.criteria.all.order(:position)
  end

  # GET /articles/1/criteria/new
  def new
    @article = Article.find(params[:article_id])
    @criterion = @article.criteria.new
    @criteria = @article.criteria.all.order(:position)
  end

  # GET /criteria/1/edit
  def edit
    @article = @criterion.article
    @criteria = @article.criteria.all.order(:position)
  end

  # POST /article/1/criteria
  # POST /article/1/criteria.json
  def create
    @article = Article.find params[:article_id]
    @criterion = @article.criteria.new(criterion_params)

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
    @article = @criterion.article
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
    @article = @criterion.article
    @criterion.destroy
    respond_to do |format|
      format.html { redirect_to article_criteria_url(@article), notice: 'Criterion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_criterion
      @criterion = Criterion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def criterion_params
      params.require(:criterion).permit(:title, :description, :abbrev, :position, :article_id)
    end
end