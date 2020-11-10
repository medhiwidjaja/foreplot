class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:signup, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users.json
  def index
    authorize! :read, User
    @users = User.match params[:match] if params[:match]
    render json: @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    authorize! :read, @user
    respond_to do |format|
      format.html
      format.json { render json: @user, status: 200 }
    end
  end

  # GET /users/1/edit
  def edit
    authorize! :update, @user
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email, :bio, :account, :role)
    end
end
