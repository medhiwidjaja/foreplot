class FollowsController < ApplicationController

  before_action :set_user

  # GET /users/1/follows
  # GET /users/1/follows.json
  def index
    @followers = @user.following_users
  end

  # POST /users/1/follows
  # POST /users/1/follows.json
  def create
    @friend = User.find params[:id]
    @user.follow @friend
    respond_to do |format|
      format.js { flash[:notice] = "You are now following #{@friend.name}" }
    end
  end

  # DELETE /users/1/follows/:id
  # DELETE /users/1/follows/:id.json
  def destroy
    @friend = User.find params[:id]
    @user.stop_following @friend
    respond_to do |format|
      format.js { flash[:notice] = "You have stopped following #{@friend.name}" }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:user_id])
    end

end
