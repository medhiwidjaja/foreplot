class AlternativesController < ApplicationController
  include TurbolinksCacheControl

  before_action :set_alternative, only: [:show, :edit, :update, :destroy]

  # GET /article/1/alternatives
  # GET /article/1/alternatives.json
  def index
    @article = Article.find params[:article_id]
    @alternatives = @article.alternatives.all.order(:position)
  end

  # GET /alternatives/1
  # GET /alternatives/1.json
  def show
    @article = @alternative.article
    @alternatives = @article.alternatives.all.order(:position)
  end

  # GET /articles/1/alternatives/new
  def new
    @article = Article.find(params[:article_id])
    @alternative = @article.alternatives.new
    @alternatives = @article.alternatives.all.order(:position)
  end

  # GET /alternatives/1/edit
  def edit
    @article = @alternative.article
    @alternatives = @article.alternatives.all.order(:position)
  end

  # POST /article/1/alternatives
  # POST /article/1/alternatives.json
  def create
    @article = Article.find params[:article_id]
    @alternative = @article.alternatives.new(alternative_params)

    respond_to do |format|
      if @alternative.save
        format.html { redirect_to @alternative, notice: 'Alternative was successfully created.' }
        format.json { render :show, status: :created, location: @alternative }
      else
        format.html { render :new, alert: @alternative.errors }
        format.json { render json: @alternative.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alternatives/1
  # PATCH/PUT /alternatives/1.json
  def update
    @article = @alternative.article
    respond_to do |format|
      if @alternative.update(alternative_params)
        format.html { redirect_to @alternative, notice: 'Alternative was successfully updated.' }
        format.json { render :show, status: :ok, location: @alternative }
      else
        format.html { render :edit }
        format.json { render json: @alternative.errors, status: :unprocessable_entity }
      end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alternative
      @alternative = Alternative.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def alternative_params
      params.require(:alternative).permit(:title, :description, :abbrev, :position, :article_id)
    end
end