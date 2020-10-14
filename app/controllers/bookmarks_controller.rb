class BookmarksController < ApplicationController

  before_action :set_user

  # GET /users/1/follows
  # GET /users/1/follows.json
  def index
    @followers = @user.following_articles
  end

  # POST /users/1/follows
  # POST /users/1/follows.json
  def create
    @article = Article.find params[:id]
    @user.follow @article
    respond_to do |format|
      format.js { flash[:notice] = "You are now following #{@article.title}" }
    end
  end

  # DELETE /users/1/follows/:id
  # DELETE /users/1/follows/:id.json
  def destroy
    @article = Article.find params[:id]
    @user.stop_following @article
    respond_to do |format|
      format.js { flash[:notice] = "You have stopped following #{@article.title}" }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:user_id])
    end

end
