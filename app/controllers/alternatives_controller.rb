class AlternativesController < ApplicationController
  include TurbolinksCacheControl
  before_action :set_alternative, only: [:show, :edit, :update, :destroy]

  # GET /article/1/alternatives
  # GET /article/1/alternatives.json
  def index
    @article = Article.find params[:article_id]
    @alternatives = @article.alternatives.order_by_position
  end

  # GET /alternatives/1
  # GET /alternatives/1.json
  def show
    @article = @alternative.article
    @alternatives = @article.alternatives.order_by_position
  end

  # GET /articles/1/alternatives/new
  def new
    @article = Article.find(params[:article_id])
    @alternative = @article.alternatives.new
    @alternatives = @article.alternatives.order_by_position
  end

  # GET /alternatives/1/edit
  def edit
    @article = @alternative.article
    @alternatives = @article.alternatives.order_by_position
  end

  # POST /article/1/alternatives
  def create
    @article = Article.find params[:article_id]
    @alternative = @article.alternatives.new(alternative_params)

    if @alternative.save
      redirect_to @alternative, notice: 'Alternative was successfully created.'
    else
      render :new, alert: @alternative.errors
    end
  end

  # PATCH/PUT /alternatives/1
  def update
    @article = @alternative.article
    if @alternative.update(alternative_params)
      redirect_to @alternative, notice: 'Alternative was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /alternatives/1
  # DELETE /alternatives/1.json
  def destroy
    @article = @alternative.article
    @alternative.destroy
    respond_to do |format|
      format.html { redirect_to article_alternatives_url(@article), notice: 'Alternative was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PATCH /articles/1/alternatives/update_all
  def update_all
    @alternatives = Alternative.update alternatives_params.keys, alternatives_params.values
    respond_to do |format|
      format.js { flash.now[:notice] = "Updated succesfully." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alternative
      @alternative = Alternative.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def alternative_params
      params.require(:alternative).permit(:title, :description, :abbrev, :position, :article_id)
    end

    def alternatives_params
      params.require(:alternatives) #.permit(:alternatives => [:position])
    end
end