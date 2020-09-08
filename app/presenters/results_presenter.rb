class ResultsPresenter < BasePresenter
  attr_reader :article, :member, :member_id, :criteria, :allow_navigate
  
  def initialize(presentable, curr_user=nil, **params)
    super(presentable, curr_user)
    @article   = presentable
    @criteria  = @article.criteria
    @goal      = @criteria.root
    @alternatives = @article.alternatives
    @member    = params[:member_id] ? Member.find(params[:member_id]) : relevant_member(@article)
    @member_id = params[:member_id] || @member.id
    @result    = ResultCalculator.new @article, @goal, @member
    @allow_navigate = true
  end

  def table
  end

  def chart
  end

  def root
    @goal
  end

  private

  def relevant_member(article)
    article.members.with_user_id(current_user.id).take || article.members.author.take
  end
end