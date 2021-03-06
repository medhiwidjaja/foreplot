class ArticlesController < ApplicationController
  include TurbolinksCacheControl
  
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :show
  
  # GET /articles
  # GET /articles.json
  def index
    @articles = current_user.articles.paginate(page: params[:page])
    authorize! :read, @articles.first
  end

  def my
    @articles = current_user.articles.paginate(page: params[:page])
    authorize! :read, @articles.first
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    authorize! :read, @article
  end

  # GET /articles/new
  def new
    @article = Article.new user: current_user, private: false
    authorize! :create, @article
  end

  # GET /articles/1/edit
  def edit
    authorize! :update, @article
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    authorize! :create, @article
    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    authorize! :update, @article
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.' 
    else
      render :edit
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    authorize! :destroy, @article
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def featured
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :description, :likes, :slug, :private, :active, :user_id)
    end

end
