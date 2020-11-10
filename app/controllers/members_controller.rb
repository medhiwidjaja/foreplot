class MembersController < ApplicationController
  include TurbolinksCacheControl
  
  before_action :set_article, only: [:index, :new, :create, :new_request]
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  # GET /articles/1/members
  # GET /articles/1/members.json
  def index
    authorize! :read, @article
    @members = @article.members.includes(:user)
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @article = @member.article
    authorize! :update, @article
  end

  # GET /articles/1/members/new
  def new
    authorize! :update, @article
    @member = @article.members.new
  end

  # GET /members/1/edit
  def edit
    @article = @member.article
    authorize! :update, @article
  end

  # POST /articles/1/members
  # POST /articles/1/members.json
  def create
    @article = Article.new(article_params)
    authorize! :create, @article
    if @article.save
      redirect_to article_members_path(@article), notice: 'Member was successfully added.'
    else
      render :new
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    @article = @member.article
    authorize! :update, @article
    if @member.update(member_params)
      redirect_to article_members_path(@article), notice: 'Member was successfully updated.' 
    else
      render :edit
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @article = @member.article
    authorize! :update, @article
    @member.destroy
    respond_to do |format|
      format.html { redirect_to article_members_path(@article), notice: 'Member was successfully removed.' }
      format.json { head :no_content }
    end
  end

  def new_request
    #authorize! :read, @article
  end

  private
    def set_article
      @article = Article.find(params[:article_id])
    end

    def set_member
      @member = Member.find(params[:id])
    end

    def member_params
      params.require(:members).permit(:user_id, :role)
    end

end
