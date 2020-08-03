class CriteriaController < ApplicationController
  include TurbolinksCacheControl

  before_action :set_criterion, only: [:show, :new, :edit, :update, :destroy]
  before_action :set_article_member, except: [:tree, :create, :update]
  before_action :set_tree, only: [:index, :edit, :new]

  # GET /article/1/criteria
  # GET /article/1/criteria.json
  def index
    @criteria = @article.criteria.all
    @root = @criteria.root
    # Stub this for now
    @table = @root.children.map {|c| {no: 1, title: c.title, weight: 0.2 }}
  end

  # GET /criteria/1
  # GET /criteria/1.json
  def show
    @article = @criterion.article
    @criteria = @article.criteria.all
    @table = @criterion.children.map {|c| {no: 1, title: c.title, weight: 0.2 }}
    appraisal_service = AppraisalService.new @criterion, @member
    @comparison = appraisal_service.get_comparison
    respond_to do |format|
      format.html { @tree = @article.criteria.root.to_tree }
      format.js 
    end
  end

  # GET /criteria/1/new
  def new
    @parent = Criterion.find(params[:id])
    @parent_id = @parent.id
    @criterion = @article.criteria.new
    @criteria = @article.criteria.all
  end

  def tree
    @root = Criterion.find(params[:id]).to_tree
    respond_to do |format|
      format.json { render 'tree', locals: {node: @root}}
    end
  end

  # GET /criteria/1/edit
  def edit
    @criteria = @article.criteria.all
    @parent_id = @criterion.parent_id
  end

  # POST /criteria/1
  # POST /criteria/1.json
  def create
    @parent_id = params[:id]
    @parent = Criterion.find @parent_id
    @article = @parent.article
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
    @parent = @criterion.parent
    @criterion.destroy
    respond_to do |format|
      format.html { redirect_to @parent, notice: 'Criterion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_criterion
      @criterion = Criterion.find(params[:id])
    end

    def set_tree
      @tree = @article.criteria.root.to_tree
    end

    def set_article_member
      if params[:article_id]
        @article = Article.find params[:article_id]
      else 
        @article = @criterion.article
      end
      @member = if params[:member_id] 
                  @article.members.where(user_id: params[:member_id]).take
                else
                  @article.members.where(user: current_user).take
                end
    end

    # Only allow a list of trusted parameters through.
    def criterion_params
      params.require(:criterion).permit(:title, :description, :abbrev, :position, :appraisal_method, :comparison_type, :parent_id, :article_id)
    end
end